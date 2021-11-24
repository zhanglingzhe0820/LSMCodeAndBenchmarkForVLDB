from algorithm_utils_lingzhe import *
import sys


def npydata2csv(npy_data, path_out, line_num=-1):
    # npy_data = np.load(path_in)
    r, c = np.shape(npy_data)
    if line_num > r or line_num == -1:
        line_num = r
    with open(path_out, 'w') as file_out:
        for i in range(line_num):
            for j in range(c):
                file_out.write(str(int(float(npy_data[i, j]))) + ',')
            file_out.write('\n')


if __name__ == '__main__':
    # sys.argv[1]
    mu = float(sys.argv[1])
    sigma = float(sys.argv[2])
    generate_time_interval = int(sys.argv[3])
    tuple_num = int(sys.argv[4])
    procs = int(sys.argv[5])
    if len(sys.argv) == 7:
        out_path = sys.argv[6].strip()
    else:
        out_path = 'mu-' + str(mu) + '-sigma-' + str(sigma) + '-interval-' + str(
            generate_time_interval) + '-num-' + str(tuple_num) + ".csv"
    data = generate_data_points_with_delay(generate_time_interval, int(tuple_num * 1.2), mu, sigma, proc=1,
                                           truncate=tuple_num)
    npydata2csv(data, out_path, line_num=tuple_num)
