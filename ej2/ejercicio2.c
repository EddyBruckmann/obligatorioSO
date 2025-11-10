#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>

sem_t mutex, mutexLec;

void* fOficinistas(void *x){
	int id = *(int *)x;
	usleep((rand() % 100)  * 5000);
	sem_wait(&mutex);
	sem_post(&mutex);
	printf("oficinista %d está modificando el cartel\n",id);

	return NULL;
}


void* fPasajeros(void* x){
	int id = *(int *)x;
	usleep((rand() % 100) * 3000);
	sem_wait(&mutexLec);
	sem_wait(&mutex);
	sem_post(&mutex);
	sem_post(&mutexLec);
	printf("Pasajero %d está leyendo el cartel\n",id);
}


int main(){	
	sem_init(&mutex, 0,1);
	sem_init(&mutexLec,0,100);

	pthread_t oficinistas[5], pasajeros[100];
	int idsOfi[5], idsPasaj[100];
	srand((unsigned)getpid());

	pthread_attr_t attr;	
	pthread_attr_init(&attr);
	for(int i = 0; i<5; i++){
		idsOfi[i] = i+1;
		pthread_create(&oficinistas[i], &attr, fOficinistas, &idsOfi[i]);
	}

	for(int i = 0; i<5; pthread_join(oficinistas[i++], NULL));

	for(int i =0; i<100; i++){
		idsPasaj[i] = i+1;
		pthread_create(&pasajeros[i], &attr, fPasajeros, &idsPasaj[i]);

	}

	for(int i = 0; i<100; pthread_join(pasajeros[i++], NULL));


	return 0;
}
