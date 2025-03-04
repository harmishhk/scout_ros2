#!/bin/bash

ros2 run xacro xacro scout_v2.xacro > scout_v2.urdf

# Define robot as a variable
robot="scout_mini"

# Create robot standalone urdf
mkdir -p "${robot}_standalone/meshes"
ros2 run xacro xacro "${robot}.xacro" > "${robot}_standalone/${robot}.urdf"

# Copy mesh files
grep -oP 'package://scout_description/meshes/[^"]+' "${robot}_standalone/${robot}.urdf" | sort -u | while read -r file; do
  cp "../meshes/$(basename "$file")" "${robot}_standalone/meshes/"
done

# Replace the package path in the XML file with absolute paths
sed -i "s|package://scout_description/meshes|meshes|g" "${robot}_standalone/${robot}.urdf"
