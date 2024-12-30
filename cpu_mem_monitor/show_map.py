import sys
import matplotlib.pyplot as plt

def plot_data(file_path, target_string, col_num):

    with open(file_path, 'r') as file:
        lines = file.readlines()

    data = []

    # 提取匹配行的最后一列数据
    for line in lines:
        if target_string in line:
           # print(line)
            columns = line.split()
           # print(columns)
            last_column = columns[int(col_num)]
            #print(last_column)
            match target_string:
                case "Mem":
                    last_column = (4000000 - int(last_column))
                case _:
                    last_column = (100.00 - float(last_column))
                
            data.append(float(last_column))
            #print(data)

    # 绘制折线图
    x = range(1, len(data) + 1)  # 使用整数索引作为x轴数据
    plt.plot(x, data)
    plt.show()

# 从命令行参数获取文件路径和匹配字符
file_path = sys.argv[1]
target_string = sys.argv[2]
col_num = sys.argv[3]
plot_data(file_path, target_string, col_num)