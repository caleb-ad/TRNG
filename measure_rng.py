def count_1(vstr):
    count = 0
    for c in vstr:
        if c == "1":
            count += 1
    print(f"1s {count}, 0s {len(vstr) - count}, %1s {count / len(vstr)}")
    return count


def longest_streak(vstr):
    max_length = 1;
    length = 1
    stype = vstr[0]
    for c in vstr[1:]:
        if c == stype:
            length += 1
        else:
            if length > max_length: max_length = length
            length = 1
            stype = c
    return (max_length, stype)

if __name__ == "__main__":
    vals = [0xe816, 0xa01e, 0x0081, 0x9caf, 0x66d2, 0x74fa, 0x2e49, 0x8807, 0x67fd, 0xf6f9, 0x6e2a, 0x6589]
    val_str = "".join(["{:16b}".format(i) for i in vals])
    count_1(val_str)
    print(longest_streak(val_str))
