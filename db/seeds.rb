# frozen_string_literal: true

PrinterDefinition.create_with(
  driver: 'marlin',
  extruder_count: 1,
).find_or_create_by!(name: 'Ultimaker 2+')

printer_definition = PrinterDefinition.create_with(
  driver: 'marlin',
  extruder_count: 2,
).find_or_create_by!(name: 'Generic Marlin Printer')

material = Material.create!(
  name: 'PLA',
  brand: 'Generic',
  filament_diameter: 2.85,
  net_filament_weight: 1000,
  empty_spool_weight: 285,
)

MaterialColor.create!(
  material: material,
  name: 'Black',
  color: '202020',
)

GCodeSettings.create!(
  printer_definition: printer_definition,
  cancel_g_code: "M104 T0 S0\nM104 T1 S0\nM140 S0\nM107\nG28 X Y\nM84",
)

UltiGCodeSettings.create!(
  printer_definition: printer_definition,
  material: material,
  hotend_temperature: 210,
  build_plate_temperature: 60,
  retraction_length: 6.5,
  end_of_print_retraction_length: 20,
  retraction_speed: 25,
  fan_speed: 100,
  flow_rate: 100,
)
