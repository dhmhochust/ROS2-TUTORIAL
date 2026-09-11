#!/usr/bin/env bash
#
# setup_tutorial3.sh
# Tutorial 3: Create and Set Up a ROS2 Workspace
#
# Yêu cầu: đã hoàn thành Tutorial 1 (ROS2 Humble đã cài, đã source setup.bash)
#
# Cách chạy:
#   chmod +x setup_tutorial3.sh
#   ./setup_tutorial3.sh
#

set -e   # Dừng script ngay nếu có lệnh nào lỗi

WORKSPACE_DIR="$HOME/ros2_ws"        # Thư mục gốc của workspace (đổi tên ở đây nếu muốn dùng dev_ws...)

source /opt/ros/humble/setup.bash    # Nạp môi trường ROS2 gốc cho phiên chạy script này

# ----- Bước 1: Tạo thư mục Workspace -----
mkdir -p "$WORKSPACE_DIR/src"        # Tạo thư mục workspace + thư mục con src/ (nơi chứa mã nguồn)
cd "$WORKSPACE_DIR"                  # Di chuyển vào thư mục gốc workspace

# ----- Bước 2: Biên dịch Workspace -----
colcon build                         # Build toàn bộ package trong src/ (đang trống, chuẩn bị cho Tutorial 4)
                                      # -> tự sinh 3 thư mục: build/, install/, log/

# ----- Bước 3: Nạp môi trường Workspace (Source Overlay) -----
source "$WORKSPACE_DIR/install/setup.bash"   # Nạp overlay workspace, PHẢI sau setup.bash gốc

# ----- Bước 4: Tự động hóa nạp môi trường -----
if ! grep -qF "source $WORKSPACE_DIR/install/setup.bash" ~/.bashrc; then
  echo "source $WORKSPACE_DIR/install/setup.bash" >> ~/.bashrc   # Thêm dòng source vào .bashrc
fi                                    # Kiểm tra tránh thêm trùng nếu chạy script nhiều lần

# ----- Kiểm tra tổng thể -----
echo "$AMENT_PREFIX_PATH"            # Xác nhận đường dẫn workspace đã có trong AMENT_PREFIX_PATH
cat ~/.bashrc | grep source          # Xem lại 2 dòng source (ROS2 gốc + workspace) trong .bashrc
