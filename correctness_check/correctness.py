with open("file1.txt", "r") as f1, open("file2.txt", "r") as f2:
    for line1, line2 in zip(f1, f2):
        if line1.strip() != line2.strip():
            print("Files are different")
            break
    else:
        print("Files are the same")
