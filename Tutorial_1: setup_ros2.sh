#!/usr/bin/env bash
#
# setup_tutorial1.sh
# Tự động hóa Tutorial 1: Install and Setup ROS2 Humble
# Yêu cầu: Ubuntu 22.04 (Jammy), quyền sudo, kết nối Internet
#
# Cách chạy:
#   chmod +x setup_tutorial1.sh
#   ./setup_tutorial1.sh
#

set -e   # Dừng script ngay nếu có lệnh nào lỗi


# --- Bước 1: Kiểm tra hệ điều hành ---

lsb_release -a
# Đảm bảo hiển thị Ubuntu 22.04 (Jammy) trước khi tiếp tục

# --- Bước 2: Thiết lập Locale (UTF-8) ---

sudo apt update && sudo apt install -y locales
# Cập nhật danh sách gói + cài công cụ quản lý locale

sudo locale-gen en_US en_US.UTF-8
# Sinh locale tiếng Anh chuẩn và bản hỗ trợ UTF-8

sudo update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8
# Đặt UTF-8 làm locale mặc định cho toàn hệ thống

export LANG=en_US.UTF-8
# Áp dụng ngay cho terminal hiện tại (phiên chạy script này)

# --- Bước 3: Thêm repository ROS2 ---
sudo apt install -y software-properties-common
# Cài công cụ cung cấp lệnh add-apt-repository

sudo add-apt-repository universe -y
# Bật kho "universe" — chứa các gói phụ thuộc mà ROS2 cần

sudo apt update && sudo apt install -y curl
# Cập nhật lại danh sách gói + cài curl (tải dữ liệu qua dòng lệnh)

sudo curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key \
  -o /usr/share/keyrings/ros-archive-keyring.gpg
# Tải khóa GPG chính thức của ROS để xác thực gói, chống giả mạo



# --- Bước 4: Cài đặt ROS2 Humble ---

sudo apt update
# Nạp lại danh sách gói để apt "biết" các gói ros-humble-* vừa thêm

sudo apt upgrade -y
# Nâng cấp gói hệ thống hiện có, tránh xung đột thư viện

sudo apt install -y ros-humble-desktop
# Cài bản đầy đủ: ROS2 core + RViz2 + Gazebo + demo mẫu
# (Dùng ros-humble-ros-base nếu chỉ cần phần lõi, không GUI)

# --- Bước 5: Cài công cụ hỗ trợ dòng lệnh ---

sudo apt install -y ros-dev-tools
# Cài colcon (build system) và rosdep (tự cài dependency còn thiếu)

# --- Bước 6: Cấu hình biến môi trường ---

if ! grep -qF "source /opt/ros/humble/setup.bash" ~/.bashrc; then
  echo "source /opt/ros/humble/setup.bash" >> ~/.bashrc
  # Thêm dòng source vào .bashrc -> tự nạp môi trường mỗi khi mở terminal mới
  echo "   Đã thêm dòng source ROS2 vào ~/.bashrc"
else
  echo "   Dòng source ROS2 đã tồn tại trong ~/.bashrc, bỏ qua."
fi

source /opt/ros/humble/setup.bash
# Áp dụng ngay cho phiên terminal hiện tại (đang chạy script)

# --- Bước 7: Kiểm tra cài đặt ---
echo ">> Bước 7: Kiểm tra biến môi trường..."
printenv | grep -i ROS || true
# Kỳ vọng thấy: ROS_DISTRO=humble, ROS_VERSION=2, ROS_PYTHON_VERSION=3
