int set_interface_attribs(int fd, int speed)
{

}


int main()
{

    return 0;


    do {
        unsigned char buf[83];
        unsigned char *p;
        int rdlen;

        rdlen = read(fd, buf, sizeof(buf) - 1);
        if (rdlen > 0) {
            buf[rdlen] = 0;

        } else if (rdlen < 0) {
            printf("Error from read: %d: %s\n", rdlen, strerror(errno));
        } else {  /* rdlen == 0 */
            printf("Nothing read. EOF?\n");
        }
    } while (1);
}
