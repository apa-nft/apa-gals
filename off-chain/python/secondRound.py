import hashlib
import json


def get_holder_list():
    with open('../lucky10000Holders13979378.json', 'r') as holdersList:
        return json.load(holdersList)


def get_previous_winners_dict():
    with open('previousWinners.json', 'r') as prevWinners:
        return json.load(prevWinners)


def get_winners(seed: str):
    holder_list = get_holder_list()
    previous_winners = get_previous_winners_dict()
    new_winners = get_new_winners(seed, holder_list, previous_winners)
    generate_merkle_tree_list(new_winners)


def generate_merkle_tree_list(winner_dict: dict):
    winner_list = []
    for holder in winner_dict:
        temp = {'address': holder, 'totalGiven': 1}
        winner_list.append(temp)
    winner_list.append({'address': '0x553beE42d9F308Aa6DB5C7dF53bDab8d649EAD00', 'totalGiven': 300}) 
    with open('newLotteryWinners.json', 'w') as winnerFile:
        json.dump(winner_list, winnerFile)
    # test
    check_for_duplicates(winner_list)
    total = 0
    for i in winner_list:
        total += i['totalGiven']
    print("total fee mints: ", total)
    print("total addresses: ", len(winner_list))


def check_for_duplicates(winners: list):
    duplicate_dict = []
    for winner in winners:
        addy = winner['address']
        if addy in duplicate_dict:
            print("duplicate found, FIX IT: ", addy)
        else:
            duplicate_dict.append(addy)

    print("total addresses: ", len(duplicate_dict))


def get_new_winners(a: str, holders_list: list, previous_winners: dict):
    seed = str.encode(a)
    new_winners = {}
    prev_ctr = 0
    double_picked_ctr = 0
    while len(new_winners) < 98:
        h = hashlib.new('sha256')
        h.update(seed)
        r = h.digest()
        seed = r  # use the hash as the next seed
        index = int(r.hex(), base=16) % len(holders_list)
        address = holders_list[index]
        if address in previous_winners:
            prev_ctr += 1
            continue
        if address in new_winners:
            double_picked_ctr += 1
            continue
        else:
            new_winners[address] = True
    print("prev ctr ", prev_ctr)
    print("double picked ", double_picked_ctr)
    return new_winners


get_winners("d594213223d600522465adc8cb907699daeaa77ea1a3845254ae1bde9d34e3c2")

# See PyCharm help at https://www.jetbrains.com/help/pycharm/
