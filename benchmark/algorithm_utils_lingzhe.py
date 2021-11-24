from multiprocessing import Array, Process, Lock
from queue import Queue
from matplotlib import pyplot as plt
import numpy as np
import pandas as pd


def range_float(minimum, maximum, step):
    """
    Generate an arithmetic sequence, given the minimum, maximum and step size
    :param minimum: minimal value of the arithmetic sequence (inclusive)
    :param maximum: maximal value of the arithmetic sequence (inclusive)
    :param step: difference of two adjacent value in the arithmetic sequence
    :return: a list, arithmetic sequence
    """
    result = []
    current_value = minimum
    while round(current_value, 4) <= maximum:
        result.append(current_value)
        current_value += step
    return result


def generate_data_points_with_delay(time_interval, total_number, mu, sigma, proc=1, truncate=0):
    data_points = []
    if proc == 1:
        gen_times = np.array(range(total_number)) * time_interval
        delays = np.random.lognormal(mu, sigma, total_number)
        arrival_time = gen_times + delays
        data_points = np.c_[gen_times, arrival_time, delays]

    else:
        # print('proc =', proc)
        all_i = list(range(total_number))
        group_i = split_list(all_i, proc)
        # print(group_i)
        arr = Array('d', list(np.zeros(3 * total_number)))
        processes = []
        lock = Lock()
        id = 0
        print('start multi_thread')
        for i in group_i:
            process = Process(target=__generate_data_points_with_delay_worker,
                              args=(id, i, time_interval, mu, sigma, arr, lock))
            id += 1
            process.start()
            processes.append(process)
        print('committed tasks')
        for process in processes:
            process.join()
        data_points = np.reshape(arr, (-1, 3))
    data_points = np.array(data_points)
    sorted_data_points = data_points[data_points[:, 1].argsort()]
    if truncate == 0:
        return sorted_data_points
    else:
        return sorted_data_points[0:int(truncate), :]


def __generate_data_points_with_delay_worker(id, group_i, time_interval, mu, sigma, my_arr, lock):
    np.random.seed(id)
    gen_times = np.array(group_i) * time_interval
    delays = np.random.lognormal(mu, sigma, len(group_i))
    arrival_times = gen_times + delays
    ret = np.c_[group_i, gen_times, arrival_times, delays]
    with lock:
        for triple in ret:
            index = int(triple[0])
            my_arr[index * 3] = triple[1]
            my_arr[index * 3 + 1] = triple[2]
            my_arr[index * 3 + 2] = triple[3]


def generate_data_points(time_interval, total_number, mu=2.54436, sigma=0.612408, proc=1, truncate=0):
    """
    Generate a collection of data points.
    :param time_interval: interval of generate time
    :param total_number: total number of data points to generate
    :param mu: parameter of lognormal distribution function, mu
    :param sigma: parameter of lognormal distribution function, sigma
    :return: a collection data points, each data points is represented by its generate time
    """
    data_points = []
    if proc == 1:
        # print('proc=1')
        for i in range(total_number):
            generate_time = i * time_interval
            arrival_time = np.random.lognormal(mu, sigma) + generate_time
            data_points.append([generate_time, arrival_time])
        data_points = np.array(data_points)
    else:
        # print('proc =', proc)
        all_i = list(range(total_number))
        group_i = split_list(all_i, proc)
        arr = Array('d', list(np.zeros(2 * total_number)))
        processes = []
        lock = Lock()
        id = 0
        for i in group_i:
            process = Process(target=__generate_data_points_worker,
                              args=(id, i, time_interval, mu, sigma, arr, lock))
            id += 1
            process.start()
            processes.append(process)
        for process in processes:
            process.join()
        # while True:
        #     is_finish = True
        #     for p in processes:
        #         is_finish = is_finish and (not p.is_alive())
        #     if is_finish:
        #         break
        #     else:
        #         time.sleep(1)
        data_points = np.reshape(arr, (-1, 2))
    print('start sorting...')
    sorted_data_points = data_points[data_points[:, 1].argsort()]
    collection = sorted_data_points[:, 0]
    if truncate == 0:
        return collection
    else:
        return collection[0:truncate]


def __generate_data_points_worker(id, group_i, time_interval, mu, sigma, my_arr, lock):
    ret = []
    np.random.seed(id)
    for i in group_i:
        generate_time = i * time_interval
        delay = np.random.lognormal(mu, sigma)
        arrival_time = delay + generate_time
        ret.append([i, generate_time, arrival_time])
    with lock:
        for triple in ret:
            my_arr[triple[0] * 2] = triple[1]
            my_arr[triple[0] * 2 + 1] = triple[2]


def generate_data_points_gpd(time_interval, total_number, mu=0, sigma=0.0224, ksi=-0.2):
    data_points = []
    for i in range(total_number):
        generate_time = i * time_interval
        arrival_time = np.random.pareto(mu, sigma) + generate_time
        data_points.append([generate_time, arrival_time])
    data_points = np.array(data_points)
    sorted_data_points = data_points[data_points[:, 1].argsort()]
    collection = sorted_data_points[:, 0]
    return collection


def split_list(original_list, number):
    """
    Distribute the tasks into multiple groups
    :param original_list: a list of tasks
    :param number: number of groups
    :return: a list of task groups
    """
    task_groups = []
    if number >= len(original_list):
        for element in original_list:
            task_groups.append([element])
    else:
        for i in range(number):
            task_groups.append([])
        i = 0
        for element in original_list:
            task_groups[i % number].append(element)
            i += 1
    return task_groups


def shift_left(vector, step=1, fill=1):
    if step >= len(vector):
        return list(np.full((len(vector)), fill))
    else:
        # print('vector',vector)
        # print('step', step)
        ret = np.roll(vector, -step)
        left_ = len(vector) - step
        right_ = step
        ret *= np.hstack((np.ones(left_), np.zeros(right_)))
        ret += np.hstack((np.zeros(left_), np.full((right_,), fill)))
        return list(ret)


def distance(set1, set2, bin_step):
    """
    Note that the 2 sets should have the same domain
    """
    if len(set1) == 0 or len(set2) == 0:
        return 99999999999999999
    max_val = max(max(set1), max(set2))
    bin_num = int(max_val / bin_step)
    bins_index = np.arange(0, bin_num, 1)
    bin_val = bins_index * bin_step
    cdf1, _, _ = plt.hist(set1, bin_val)
    cdf2, _, _ = plt.hist(set2, bin_val)
    dist = np.linalg.norm(np.array(cdf1) - np.array(cdf2), ord=2)
    plt.cla()
    return dist


def count_point(ssts):
    ret = 0
    for sst in ssts:
        assert sst.index == 0
        ret += len(sst.data_list)
    return ret


def csv2npy(path, output=None, sort=False):
    data = np.array(pd.read_csv(path))
    if sort:
        data = data[data[:, 1].argsort()]
    if output is not None:
        arr = data[:, 0]
        gen = data[:, 1]
        delays = arr - gen
        data_ = np.c_[gen, arr, delays]
        np.save(output, data_)
    return data


def npy2csv(path_in, path_out, line_num=-1):
    data = np.load(path_in)
    r, c = np.shape(data)
    if line_num > r or line_num == -1:
        line_num = r
    with open(path_out, 'w') as file_out:
        for i in range(line_num):
            for j in range(c):
                file_out.write(str(int(float(data[i, j]))) + ',')
            file_out.write('\n')


class BufferedQueue:
    """
    A buffered queue. The size of the queue is fixed. Elements are constantly added to the queue.
    When the queue is full, the oldest element is removed to make room for the new element.
    """

    def __init__(self, maxsize) -> None:
        """
        Constructor of a BufferedQueue
        :param maxsize: maximal number of element the queue can hold
        """
        super().__init__()
        self.queue = Queue(maxsize=maxsize)
        self.element_sum = 0
        self.element_number = 0

    def put(self, val):
        """
        Add an element to the buffered queue
        :param val: the element
        """
        if self.queue.full():
            self.element_sum -= self.queue.get()
        else:
            self.element_number += 1
        self.queue.put(val)
        self.element_sum += val

    def full(self):
        return self.queue.full()

    def average(self):
        """
        Expected value of whatever in the buffered queue
        :return: the expected value
        """
        return float(self.element_sum) / self.element_number
