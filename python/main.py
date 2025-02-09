def isPrime(number):
    stop=number**0.5
    #turn to int
    stop = int(stop)
    stop = max(2, stop)  # Ensure we check at least up to 2

    for j in range(2,stop+1):
        if number%j==0:
            return False
    return True



for i in range(10):
    if isPrime(i):
        print(i)
