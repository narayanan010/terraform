import datetime


def build_object_name(file_name, user_pool_name):
    object_name = user_pool_name + "/" + str(datetime.datetime.now().date()) + "/" + file_name
    return object_name


def build_file_name(pool_id, chunk_number):
    file_name = pool_id + '_chunk_' + str(chunk_number) + '.csv'
    return file_name


def build_file_path(file_name):
    file_path = '/tmp/' + file_name
    return file_path
