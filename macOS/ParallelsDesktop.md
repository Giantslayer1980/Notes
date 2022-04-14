### 虚拟机可使用的三种网络通信模式：
共享网络(Shared Networking)、桥接网络(Bridged Networking)和Host-Only网络。

#### 共享网络
这是现成可用，无需任何特定配置的网络类型。它以Mac充当虚拟机的路由器，故虚拟机在所属的真实子网中不可见。

#### 桥接网络
虚拟机的网卡使用名为“桥接”的技术，与Mac计算机网卡进行直接连接。虚拟机与运行在其上的Mac属于同一子网，故在同一子网内有独立的IP地址。

#### Host-Only网络
此模式与共享模式类似，只不过由 Parallels Desktop 创建的虚拟子网是与外界隔离的。以 Host-Only 模式运行的虚拟机只能查看和 ping 它运行在其上的 Mac，也可以和gateway通信，但是无法访问Internet。