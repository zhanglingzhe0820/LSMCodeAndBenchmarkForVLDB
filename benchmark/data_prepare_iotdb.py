from queue import PriorityQueue
import numpy as np
import sys

np.random.seed(4834)


def triple2line(triple, delimiter=','):
    """
    Transform a triple to a line of string. The value are concatenated with given delimiter.
    :param triple: a triple containing three float values
    :param delimiter: delimiter for concatenating the values
    :return: concatenated string, ending with '\n'
    """
    return str(triple[0]) + delimiter + str(triple[1]) + delimiter + str(triple[2]) + '\n'


def progress(percent, width=100):
    """
    Show the progress of data generation
    :param percent: percentage of tasks completed
    :param width: The width of the progress bar
    """
    if percent > 1:
        percent = 1
    show_str = ('[%%-%ds]' % width) % (int(percent * width) * '#')
    print('\r%s %s%%' % (show_str, int(percent * 100)), end='', file=sys.stdout, flush=True)


if __name__ == '__main__':

    data_points_number = 10000000
    time_interval = 2.5
    buffer_size = 50000
    # parameters for delay distribution,
    mu = 4
    sigma = 1.5
    # path of the output file
    output_file_name = 'data_for_iotdb.csv'

    buffer = PriorityQueue(buffer_size)
    max_arrival_time_in_file = -1
    # number of data points written to the file
    current_num = 0
    with open(output_file_name, 'w') as file_out:
        # generate data points
        for i in range(data_points_number):
            gen_time = int(i * time_interval)
            delay = np.random.lognormal(mu, sigma)
            arrival_time = gen_time + delay
            value = np.random.uniform()
            if buffer.full():
                point = buffer.get()
                if point[0] < max_arrival_time_in_file:
                    print('drop a data point', str(point), 'because arrival time is too early.')
                    continue
                file_out.write(triple2line(point))
                max_arrival_time_in_file = point[0]
                current_num += 1
                if current_num % 1000 == 0:
                    progress(float(current_num / data_points_number))
            buffer.put((arrival_time, gen_time, delay, value))

        while not buffer.empty():
            point = buffer.get()
            if point[0] < max_arrival_time_in_file:
                print('drop a data point', str(point), 'because arrival time is too early')
                continue
            file_out.write(triple2line(point))
            max_arrival_time_in_file = point[0]
            current_num += 1
            if current_num % 1000 == 0:
                progress(float(current_num / data_points_number))
