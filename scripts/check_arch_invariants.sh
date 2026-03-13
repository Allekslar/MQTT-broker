#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "$0")/.." && pwd)"
violations=0

report_violation() {
  local rule_id="$1"
  local severity="$2"
  local file_path="$3"
  local detail="$4"
  local fix_hint="$5"

  printf '[%s] %s: %s\n' "$rule_id" "$severity" "$detail"
  printf 'file: %s\n' "$file_path"
  printf 'fix: %s\n\n' "$fix_hint"
  violations=$((violations + 1))
}

scan_matches() {
  local scope_path="$1"
  shift
  if [[ ! -d "$scope_path" ]]; then
    return 0
  fi
  rg -n "$@" "$scope_path" || true
}

core_dir="$repo_root/components"
ports_dir="$repo_root/components/ports"
main_dir="$repo_root/main"
include_dir="$repo_root/include"
components_dir="$repo_root/components"

public_header_dirs=()
[[ -d "$ports_dir/include" ]] && public_header_dirs+=("$ports_dir/include")
[[ -d "$include_dir" ]] && public_header_dirs+=("$include_dir")
if [[ -d "$components_dir" ]]; then
  while IFS= read -r header_dir; do
    [[ "$header_dir" == "$ports_dir/include" ]] && continue
    public_header_dirs+=("$header_dir")
  done < <(find "$components_dir" -mindepth 2 -maxdepth 2 -type d -name include | sort)
fi

core_matches="$(scan_matches "$core_dir" --glob '!ports/**' --glob '!diagnostics/**' --glob '!transport_*/*' --glob '!storage_*/*' '(#include\\s*[<"](esp_|freertos/|lwip/|nvs|driver/|sys/socket|arpa/inet))')"
if [[ -n "$core_matches" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    report_violation "ARCH-001" "blocker" "${line%%:*}" "core module includes platform header" "move platform dependency into adapter or runtime layer"
  done <<< "$core_matches"
fi

port_matches="$(scan_matches "$ports_dir" --glob '**/*.[hc]pp' --glob '**/*.h' '(#include\\s*[<"](esp_|freertos/|lwip/|nvs|driver/|sys/socket|arpa/inet))')"
if [[ -n "$port_matches" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    report_violation "ARCH-003" "blocker" "${line%%:*}" "port header includes platform header" "replace platform type with abstract domain or port contract type"
  done <<< "$port_matches"
fi

adapter_ref_matches="$(scan_matches "$core_dir" --glob '!ports/**' --glob '!diagnostics/**' '(transport_tcp|storage_nvs|storage_psram|diagnostics|platform_runtime)')"
if [[ -n "$adapter_ref_matches" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    report_violation "ARCH-002" "blocker" "${line%%:*}" "core module references concrete adapter name" "depend on ports/contracts instead of adapter component names"
  done <<< "$adapter_ref_matches"
fi

routing_dir="$repo_root/components/routing"
routing_adapter_matches="$(scan_matches "$routing_dir" '(transport_tcp|storage_nvs|storage_psram)')"
if [[ -n "$routing_adapter_matches" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    report_violation "ARCH-006" "blocker" "${line%%:*}" "routing references transport or storage adapter" "routing must depend only on domain types and policy ports"
  done <<< "$routing_adapter_matches"
fi

for header_dir in "${public_header_dirs[@]}"; do
  macro_hook_matches="$(scan_matches "$header_dir" --glob '**/*.[hc]pp' --glob '**/*.h' '(#if(n?def)?\\s+.*TEST|#ifdef\\s+UNIT_TEST|#ifdef\\s+TESTING)')"
  if [[ -n "$macro_hook_matches" ]]; then
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      report_violation "ARCH-008" "blocker" "${line%%:*}" "macro-gated test hook found in production public header" "move test-only access into dedicated *_test_access.hpp header"
    done <<< "$macro_hook_matches"
  fi
done

test_access_search_roots=()
[[ -d "$components_dir" ]] && test_access_search_roots+=("$components_dir")
[[ -d "$include_dir" ]] && test_access_search_roots+=("$include_dir")

if (( ${#test_access_search_roots[@]} > 0 )); then
  test_access_files="$(rg --files "${test_access_search_roots[@]}" -g '*_test_access.hpp' || true)"
  if [[ -n "$test_access_files" ]]; then
    while IFS= read -r file_path; do
      [[ -z "$file_path" ]] && continue
      if [[ "$file_path" != */include/*_test_access.hpp ]]; then
        report_violation "ARCH-007" "major" "$file_path" "test-only access header is outside an include/ layout" "place *_test_access.hpp under the owning module include tree"
      fi
    done <<< "$test_access_files"
  fi
fi

test_access_include_matches="$(scan_matches "$components_dir" --glob '!**/test/**' '(#include\\s*[<"][^">]*_test_access\\.hpp[>"])')"
main_test_access_include_matches="$(scan_matches "$main_dir" '(#include\\s*[<"][^">]*_test_access\\.hpp[>"])')"
combined_test_access_matches=""
[[ -n "$test_access_include_matches" ]] && combined_test_access_matches+="$test_access_include_matches"$'\n'
[[ -n "$main_test_access_include_matches" ]] && combined_test_access_matches+="$main_test_access_include_matches"$'\n'
if [[ -n "$combined_test_access_matches" ]]; then
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    report_violation "ARCH-007" "major" "${line%%:*}" "production code depends on a test-only access header" "keep *_test_access.hpp usage out of production code paths"
  done <<< "$combined_test_access_matches"
fi

if [[ -f "$main_dir/app_main.cpp" ]]; then
  if rg -n '(route_|acl_|qos_|session_|retain_)' "$main_dir/app_main.cpp" >/dev/null 2>&1; then
    report_violation "ARCH-004" "blocker" "$main_dir/app_main.cpp" "app_main contains policy-like logic markers" "keep app_main as composition root only"
  fi
fi

if (( violations > 0 )); then
  exit 1
fi

printf 'Architecture invariants check passed.\n'
