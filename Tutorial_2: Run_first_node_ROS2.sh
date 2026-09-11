#!/usr/bin/env bash
#
# setup_tutorial2.sh
# Tutorial 2: Start Your First ROS2 Node
# Kiểm tra môi trường ROS2 (Tutorial 1) và chạy thử node + các lệnh CLI cơ bản
#
# Yêu cầu: đã hoàn thành Tutorial 1 (ROS2 Humble đã cài, đã source setup.bash)
#
# Cách chạy:
#   chmod +x setup_tutorial2.sh
#   ./setup_tutorial2.sh
#

set -e   # Dừng script ngay nếu có lệnh nào lỗi

source /opt/ros/humble/setup.bash   # Nạp môi trường ROS2 cho phiên chạy script này (phòng khi chưa có sẵn)

# ----- Bước 2: Kiểm tra môi trường -----
printenv | grep -i ROS               # Xác nhận biến môi trường ROS_DISTRO, ROS_VERSION đã nạp đúng
which ros2                           # Xác nhận lệnh ros2 trỏ đúng vào /opt/ros/humble
ros2 doctor --report                 # Kiểm tra sức khỏe hệ thống ROS2, in báo cáo chi tiết

# ----- Bước 1: Khởi chạy node (chạy nền để test tự động) -----
ros2 run demo_nodes_cpp talker &     # Chạy node talker ở chế độ nền (&), publish message lên /chatter
TALKER_PID=$!                        # Lưu lại PID của tiến trình talker để tắt sau này

ros2 run demo_nodes_py listener &    # Chạy node listener ở chế độ nền, subscribe /chatter
LISTENER_PID=$!                      # Lưu lại PID của tiến trình listener

sleep 3                              # Đợi 3 giây để 2 node kịp khởi động và bắt đầu giao tiếp

# ----- Bước 3: Các lệnh CLI cơ bản -----
ros2 node list                       # Liệt kê node đang chạy -> kỳ vọng thấy /talker và /listener
ros2 node info /talker                # Xem chi tiết topic mà node /talker đang publish
ros2 topic list                      # Liệt kê topic đang hoạt động -> kỳ vọng thấy /chatter
ros2 topic hz /chatter --window 5 &  # Đo tần suất publish trong 5 mẫu, chạy nền để không block script
HZ_PID=$!
sleep 4                              # Đợi đủ thời gian để topic hz thu thập dữ liệu
kill "$HZ_PID" 2>/dev/null || true   # Dừng tiến trình đo hz (im lặng nếu đã tự kết thúc)

# ----- Dọn dẹp: tắt các node chạy nền -----
kill "$TALKER_PID" "$LISTENER_PID" 2>/dev/null || true   # Tắt talker và listener sau khi test xong

echo "Tutorial 2 kiểm tra hoàn tất. Chạy 'rqt_graph' thủ công nếu muốn xem sơ đồ giao tiếp trực quan."
