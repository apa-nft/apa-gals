import hashlib
import json

team_and_mod_addresses = [
    "0x2c812dAf5B0297B935A287Ad27340F2B37939F2c",
    "0x97249d330a19377e609F23D76F4B042BB639de90",
    "0xc0C799c949AD065dF04628f036f371F12C6fDf5e",
    "0x807b755d5374769dD5282a05ebAcA84CA70aF607",
    "0x2732C565BA8edCE5d7dcef5F8C97129515007B8c",
    "0x8047E8E33FaB6CaEc0841a575B3f7e266F6f745A",
    "0xE90b18f9AD03A08cd704188674a22A1dFAa40648",
    "0xf5ffB26AFBdb4a16f0812908c7863677174DE5fe",
    "0x0B6E5B8306a23Ff68D2676BDfa2005712c6552eE",
    "0x3Ecb35b0012B71f04dfA994D6dea750a17CfF0b3",
    "0x06B57259560876E6979b65b27E70EEDbcE96eDF0",
    "0x3b707d52b2625e9d946d55bd5c07748A9C8700a9",
    "0x90A71c12271047cdFF20cD85e73592c4eD82528d",
    "0x13e77925c3998aA8e845e84F1b71F2b8ecD1EE92",
    "0x6ac5152ce147fcc8010699072Ae86e080e27628c",
    "0xBd2790a75ad828bE74025bEF26F2122d15E372A1",
    "0x16024f29265A330335a3B6A1b5C786bdA07f9E4C",
    "0x8335ec1D5789c25Be9c236bD590B60D66B941423",
    "0x1793d9B7ff6C67650828e912bD384EA19600435B",
    "0x694BCdc7439A3d0ce0162449312Cf822b216AF0f",
    "0xE541F399af344CF8077Cc2852ABc03f92760AbB2",
    "0xBc63c33840750d3eDaa6E446CE723698601D2650",
    "0x30547B9bf55560c085dEA662d0A94D737A1EEE6c",
    "0x622b36e8D8Abd7aa1968Dbf32F17e53EBedD3faE",
    "0xe342F99f6826229014d1Ab6a4A3ffeb3Dbd18eAE",
    "0x97103ebc161fe6f255f5ac455baccf0f83402a28",
    "0x87ea93d6D50BE6D7Fd73E127A9b31FB13Cc3898D",
    '0x2c812dAf5B0297B935A287Ad27340F2B37939F2c',
    '0x97249d330a19377e609F23D76F4B042BB639de90',
    '0xc0C799c949AD065dF04628f036f371F12C6fDf5e',
    '0x90A71c12271047cdFF20cD85e73592c4eD82528d',
    '0x1793d9B7ff6C67650828e912bD384EA19600435B',
    '0xE90b18f9AD03A08cd704188674a22A1dFAa40648']


def get_holder_list():
    with open('../lucky10000Holders.json', 'r') as holdersList:
        return json.load(holdersList)


def get_winners(seed: str):
    winner_dict = {}
    holder_list = get_holder_list()
    random_indexes_list = get_random_indices(seed, len(holder_list))
    print("Total Holder (Marketplace not taken into account): ", len(holder_list))
    for i in random_indexes_list:
        holder_address = holder_list[i]
        if holder_address in winner_dict:
            current_value = winner_dict[holder_address]
            winner_dict[holder_address] = current_value + 1
        else:
            winner_dict[holder_address] = 1

    for addy in team_and_mod_addresses:
        if addy in winner_dict:
            current_value = winner_dict[addy]
            winner_dict[addy] = current_value + 1
        else:
            winner_dict[addy] = 1
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
