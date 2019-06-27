--[[ Copyright (c) 2017 Optera
 * Part of Logistics Train Network
 *
 * See LICENSE.md in the project directory for license information.
--]]

data:extend({
  {
    type = "bool-setting",
    name = "ltn-dispatcher-enabled",
    order = "aa",
    setting_type = "runtime-global",
		default_value = true
  },
  {
    type = "int-setting",
    name = "ltn-dispatcher-stops-per-tick",
    order = "ab",
    setting_type = "runtime-global",
		default_value = 2,
    minimum_value = 1,
    maximum_value = 4294967295, -- prevent 32bit signed overflow
  },
  {
    type = "string-setting",
    name = "ltn-interface-console-level",
    order = "ac",
    setting_type = "runtime-global",
    default_value = "2: Notifications",
    allowed_values =  {"0: Off", "1: Errors & Warnings", "2: Notifications", "3: Detailed Messages"}
  },
  {
    type = "int-setting",
    name = "ltn-interface-message-filter-age",
    order = "ad",
    setting_type = "runtime-global",
    default_value = 18000,
    minimum_value = 0,
    maximum_value = 4294967295, -- prevent 32bit signed overflow
  },
	{
    type = "bool-setting",
    name = "ltn-interface-debug-logfile",
    order = "ae",
    setting_type = "runtime-global",
		default_value = false
  },
  {
    type = "int-setting",
    name = "ltn-dispatcher-requester-threshold",
    order = "ba",
    setting_type = "runtime-global",
    default_value = 1000,
    minimum_value = 1,
    maximum_value = 4294967295, -- prevent 32bit signed overflow
  },
  {
    type = "int-setting",
    name = "ltn-dispatcher-provider-threshold",
    order = "bb",
    setting_type = "runtime-global",
    default_value = 1000,
    minimum_value = 1,
    maximum_value = 4294967295, -- prevent 32bit signed overflow
  },
  {
    type = "bool-setting",
    name = "ltn-dispatcher-schedule-circuit-control",
    order = "ca",
    setting_type = "runtime-global",
    default_value = false
  },
  {
    type = "int-setting",
    name = "ltn-dispatcher-depot-inactivity(s)",
    order = "cb",
    setting_type = "runtime-global",
    default_value = 5, --5s
    minimum_value = 1, --1s
    maximum_value = 4294967295, -- prevent 32bit signed overflow
  },
  {
    type = "int-setting",
    name = "ltn-dispatcher-stop-timeout(s)",
    order = "cc",
    setting_type = "runtime-global",
    default_value = 120, --2min
    minimum_value = 0, --0:off
    maximum_value = 4294967295, -- prevent 32bit signed overflow
  },
  {
    type = "int-setting",
    name = "ltn-dispatcher-delivery-timeout(s)",
    order = "cd",
    setting_type = "runtime-global",
    default_value = 600, --10min
    minimum_value = 60, -- 1min
    maximum_value = 4294967295, -- prevent 32bit signed overflow
  },
  {
    type = "bool-setting",
    name = "ltn-dispatcher-requester-delivery-reset",
    order = "ce",
    setting_type = "runtime-global",
    default_value = false
  },
  {
    type = "bool-setting",
    name = "ltn-dispatcher-finish-loading",
    order = "cf",
    setting_type = "runtime-global",
    default_value = true
  },
  {
    type = "bool-setting",
    name = "ltn-depot-reset-filters",
    order = "da",
    setting_type = "runtime-global",
    default_value = true
  },
  {
    type = "int-setting",
    name = "ltn-stop-default-network",
    order = "ea",
    setting_type = "runtime-global",
    default_value = -1, -- any
  },
})