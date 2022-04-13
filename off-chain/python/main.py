import hashlib
import json


def get_holder_list():
    with open('../lucky10000Holders.json', 'r') as holdersList:
        return json.load(holdersList)


def get_winners(seed: str):
    winner_dict = {}
    holder_list = get_holder_list()
    random_indexes_list = get_random_indices(seed, len(holder_list))
    print("Total Holder (Marketplace not taken into account): ",len(holder_list))
    for i in random_indexes_list:
        holder_address = holder_list[i]
        if holder_address in winner_dict:
            current_value = winner_dict[holder_address]
            winner_dict[holder_address] = current_value + 1
        else:
            winner_dict[holder_address] = 1
    # convert to merkle format
    generate_merkle_tree_list(winner_dict)


def generate_merkle_tree_list(winner_dict: dict):
    winner_list = []
    for holder in winner_dict:
        temp = {'address': holder, 'totalGiven': winner_dict[holder]}
        winner_list.append(temp)
    with open('../lotteryWinners.json', 'w') as winnerFile:
        json.dump(winner_list, winnerFile)
    # test
    total = 0
    for i in winner_list:
        total += i['value']
    print(total)
 


def get_random_indices(a: str, length):
    seed = str.encode(a)
    random_indices = []
    duplicate_dict = {}
    while len(random_indices) < 900:
        h = hashlib.new('sha256')
        h.update(seed)
        r = h.digest()
        seed = r  # use the hash as the next seed
        index = int(r.hex(), base=16) % length
        if index in duplicate_dict:
            continue
        else:
            duplicate_dict[index] = True
        random_indices.append(index)
    return random_indices


get_winners("e7d481809581e0b99b16ee526b040f10c26cc778a523af6e9e214129de926c5a")


# See PyCharm help at https://www.jetbrains.com/help/pycharm/
