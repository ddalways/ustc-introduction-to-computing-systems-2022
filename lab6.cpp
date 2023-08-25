#include <cstdint>
#include <iostream>
#include <fstream>

#define MAXLEN 100
#ifndef LENGTH
#define LENGTH 3
#endif

int16_t lab1(int16_t a, int16_t b)
{
    if (b>16) return -1;//若b>16，返回-1
    
    int16_t count = 0;
    int16_t mask = 1;
    for (int i = 0; i < b; i++)
    {
        if (a & mask)
            count++;
        mask = mask + mask;
    }
    return count;
}

//lab2 计算模q
int16_t modeq(int16_t a, int16_t q)
{
    while (a >= q)
        a = a - q;
    return a;
}

int16_t lab2(int16_t p, int16_t q, int16_t n)
{
    if (n == 0)
        return 1;
    if (n == 1)
        return 1;
    int16_t N_1 = 1, N_2 = 1;   // 分别为F(N-1)%p和F(N-2)%q
    int16_t FN_1 = 1, FN_2 = 1; // 分别保存F(N-1)和F(N-2)
    int16_t FN;
    for (int i = 0; i < n - 1; i++)
    {
        N_1 = modeq(FN_1, q);
        N_2 = FN_2 & (p - 1);
        FN = N_2 + N_1;
        FN_2 = FN_1;
        FN_1 = FN;
    }
    return FN;
}

int16_t lab3(int16_t n, char s[])
{
    int repeat = 0, max = 0;
    if (n == 0)
        return 0;
    for (int i = 0; i < n - 1; i++)
    {
        if (s[i + 1] == s[i]) // 下一个字符与当前字符相同
            repeat++;
        if (repeat > max) // 若当前重复子串长度大于已有的最长子串长度，更新max的值
            max = repeat;
        if (s[i + 1] != s[i]) // 下一个字符与当前字符不同
            repeat = 0;
    }
    return max + 1;
}

void lab4(int16_t score[], int16_t *a, int16_t *b)
{
    int tmp;
    // 冒泡排序
    for (int i = 15; i > 0; i--)
    {
        for (int j = 0; j < i; j++)
        {
            if (score[j] > score[j + 1]) // 若前者成绩高于后者，交换两个成绩的顺序
            {
                tmp = score[j];
                score[j] = score[j + 1];
                score[j + 1] = tmp;
            }
        }
    }
    int i = 0, j = 0;
    *a = *b = 0;
    for (i = 0; i < 4; i++)
    {
        if (score[15 - i] >= 85) // 符合A的标准
            (*a)++;
    }
    for (j = *a; j < 8; j++)
    {
        if (score[15 - j] >= 75) // 符合B的标准
            (*b)++;
    }
}

int main()
{
    std::fstream file;
    file.open("test.txt", std::ios::in);

    // lab1
    int16_t a = 0, b = 0;
    for (int i = 0; i < LENGTH; i++)
    {
        file >> a >> b;
        std::cout << lab1(a, b) << std::endl;
    }

    // lab2
    int16_t p = 0, q = 0, n = 0;
    for (int i = 0; i < LENGTH; i++)
    {
        file >> p >> q >> n;
        std::cout << lab2(p, q, n) << std::endl;
    }

    // lab3
    char s[MAXLEN];
    for (int i = 0; i < LENGTH; i++)
    {
        file >> n >> s;
        std::cout << lab3(n, s) << std::endl;
    }

    // lab4
    int16_t score[16];
    for (int i = 0; i < LENGTH; i++)
    {
        for (int j = 0; j < 16; j++)
        {
            file >> score[j];
        }
        lab4(score, &a, &b);
        for (int j = 0; j < 16; j++)
        {
            std::cout << score[j] << " ";
        }
        std::cout << std::endl
                  << a << " " << b << std::endl;
    }
    file.close();
    return 0;
}