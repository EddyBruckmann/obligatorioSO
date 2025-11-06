#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>

sem_t mutex;

void* fOficinistas(void *x){
	int id = *(int *)x;
	usleep((rand() % 100)  * 5000);
	sem_wait(&mutex);
	sem_post(&mutex);
	printf("oficinista %d está modificando el cartel\n",id);

	return NULL;
}



int main(){	
	sem_init(&mutex, 0,1);

	pthread_t oficinistas[5];
	int idsOfi[5];
	srand((unsigned)getpid());

	pthread_attr_t attr;	
	pthread_attr_init(&attr);
	for(int i = 0; i<5; i++){
		idsOfi[i] = i+1;
			pthread_create(&oficinistas[i], &attr, fOficinistas, &idsOfi[i]);

	}

	for(int i = 0; i<5; pthread_join(oficinistas[i++], NULL));

	return 0;
}
