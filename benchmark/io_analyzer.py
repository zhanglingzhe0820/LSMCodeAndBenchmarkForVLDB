import sys

path = sys.argv[1]
line_num = 0
total_value = 0
for line in open(path, "r"):
    if "sda" in line:
        if line_num > 0:
            value_list = line.split(" ")
            value = value_list[-1].split("\n")[0]
            total_value += int(value)
        line_num += 1
print(total_value)
