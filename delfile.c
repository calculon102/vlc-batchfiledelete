#include <stdio.h>

int main (int argc, char * argv[])
{
	if (argc < 2) {
		puts("Usage: delfile PATH_TO_DELETE");
		return 0;
	}
	
	if ( remove( argv[1] ) != 0 ) {
    	perror("Error deleting file");
    }
    else {
    	printf("File deleted: %s", argv[1]);
    }
    
    puts("");
    	
	return 0;
}
