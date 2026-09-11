#!/usr/bin/env bash
#
# setup_tutorial5.sh
# Tutorial 5: Create a ROS2 Node with Python and OOP
#
# Yêu cầu: đã hoàn thành Tutorial 4 (package my_py_pkg đã tồn tại trong ~/ros2_ws/src)
# Script sẽ: copy first_node.py vào package, thêm entry_points vào setup.py, build và chạy thử
#
# Cách dùng:
#   chmod +x setup_tutorial5.sh
#   ./setup_tutorial5.sh [tên_package]
#   (nếu không truyền tham số, mặc định package=my_py_pkg)
#

set -e   # Dừng script ngay nếu có lệnh nào lỗi

WORKSPACE_DIR="$HOME/ros2_ws"          # Thư mục gốc workspace, phải khớp với Tutorial 3
PKG_NAME="${1:-my_py_pkg}"             # Tên package -> lấy tham số 1, mặc định "my_py_pkg"
PKG_DIR="$WORKSPACE_DIR/src/$PKG_NAME" # Đường dẫn tới thư mục package
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # Thư mục chứa script này (nơi có first_node.py)

source /opt/ros/humble/setup.bash              # Nạp môi trường ROS2 gốc
source "$WORKSPACE_DIR/install/setup.bash"     # Nạp overlay workspace

# ----- Bước 1: Copy mã nguồn node vào package -----
cp "$SCRIPT_DIR/first_node.py" "$PKG_DIR/$PKG_NAME/first_node.py"
# Copy file first_node.py (đi kèm trong repo) vào đúng thư mục source của package

# ----- Bước 4: Đăng ký entry_points trong setup.py -----
SETUP_PY="$PKG_DIR/setup.py"

if ! grep -qF "first_node = ${PKG_NAME}.first_node:main" "$SETUP_PY"; then
  # Kiểm tra tránh thêm trùng dòng entry_points nếu script chạy lại nhiều lần
  sed -i "s|'console_scripts': \[|'console_scripts': [\n            'first_node = ${PKG_NAME}.first_node:main',|" "$SETUP_PY"
  # sed -i -> chỉnh sửa trực tiếp file setup.py
  # Tìm dòng "'console_scripts': [" và chèn thêm dòng đăng ký lệnh "first_node" ngay bên dưới
fi

# ----- Bước 5: Biên dịch và kiểm tra -----
cd "$WORKSPACE_DIR"                    # colcon build luôn chạy từ thư mục gốc workspace

colcon build --packages-select "$PKG_NAME"   # Build lại package để áp dụng node mới + entry_points mới

source "$WORKSPACE_DIR/install/setup.bash"   # Nạp lại overlay để ROS2 nhận diện lệnh "first_node"

ros2 pkg executables "$PKG_NAME"       # Liệt kê các lệnh thực thi có sẵn -> xác nhận "first_node" đã đăng ký
