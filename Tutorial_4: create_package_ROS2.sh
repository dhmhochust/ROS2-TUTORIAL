#!/usr/bin/env bash
#
# setup_tutorial4.sh
# Tutorial 4: Create a ROS2 Python Package
#
# Yêu cầu: đã hoàn thành Tutorial 1 và Tutorial 3 (workspace ~/ros2_ws/src đã tồn tại)
#
# Cách dùng:
#   chmod +x setup_tutorial4.sh
#   ./setup_tutorial4.sh [tên_package] [tên_node]
#   (nếu không truyền tham số, mặc định package=my_py_pkg, node=my_node)
#

set -e   # Dừng script ngay nếu có lệnh nào lỗi

WORKSPACE_DIR="$HOME/ros2_ws"          # Thư mục gốc workspace, phải khớp với Tutorial 3
PKG_NAME="${1:-my_py_pkg}"             # Tên package -> lấy tham số 1, mặc định "my_py_pkg" nếu không truyền
NODE_NAME="${2:-my_node}"              # Tên node mẫu -> lấy tham số 2, mặc định "my_node" nếu không truyền

source /opt/ros/humble/setup.bash              # Nạp môi trường ROS2 gốc
source "$WORKSPACE_DIR/install/setup.bash"     # Nạp overlay workspace đã tạo ở Tutorial 3

# ----- Bước 1: Khởi tạo Package -----
cd "$WORKSPACE_DIR/src"                # Mọi package phải được tạo trong thư mục src/

ros2 pkg create --build-type ament_python --node-name "$NODE_NAME" "$PKG_NAME"
# --build-type ament_python -> chỉ định build system cho package Python
# --node-name               -> tự sinh sẵn 1 file node mẫu để test nhanh
# "$PKG_NAME"                -> tên package lấy từ tham số dòng lệnh

# ----- Bước 3: Biên dịch Package -----
cd "$WORKSPACE_DIR"                    # colcon build luôn phải chạy từ thư mục gốc workspace

colcon build --packages-select "$PKG_NAME"   # Chỉ build riêng package vừa tạo cho nhanh

source "$WORKSPACE_DIR/install/setup.bash"   # Nạp lại overlay để ROS2 nhận diện package mới

# ----- Kiểm tra kết quả -----
ros2 pkg list | grep "$PKG_NAME"       # Xác nhận package đã được đăng ký vào hệ thống ROS2
