#include <pthread.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <semaphore.h>

sem_t mutex, semOfi;
const int cantOfi = 5;
const int cantPasj = 100;
int pasajActuales = 0;
int infoVuelo = 0;

void *fOficinistas(void *x)
{
	int id = *(int *)x;
	usleep((rand() % 100) * 5000);
	for (int k = 0; k < 3; k++)
	{

		sem_wait(&mutex);
		infoVuelo = rand()*100;
		printf("oficinista %d escribió %d en el cartel\n", id, infoVuelo);
		usleep(100);
		sem_post(&mutex);
	}
	return NULL;
}

void *fPasajeros(void *x)
{
	int id = *(int *)x;
	usleep((rand() % 100) * 3000);
	sem_wait(&semOfi);
	pasajActuales++;
	if (pasajActuales == 1)
		sem_wait(&mutex);
	sem_post(&semOfi);

	printf("Pasajero %d leyó %d en el cartel\n", id, infoVuelo);
	usleep(100);
	sem_wait(&semOfi);
	pasajActuales--;
	if (pasajActuales == 0)
		sem_post(&mutex);
	sem_post(&semOfi);
	return NULL;
}

int main()
{
	sem_init(&mutex, 0, 1);
	sem_init(&semOfi, 0, 1);

	pthread_t oficinistas[5], pasajeros[100];
	int idsOfi[5], idsPasaj[100];
	srand((unsigned)getpid());

	pthread_attr_t attr;
	pthread_attr_init(&attr);
	for (int i = 0; i < cantOfi; i++)
	{
		idsOfi[i] = i + 1;
		pthread_create(&oficinistas[i], &attr, fOficinistas, &idsOfi[i]);
	}


	for (int i = 0; i < cantPasj; i++)
	{
		idsPasaj[i] = i + 1;
		pthread_create(&pasajeros[i], &attr, fPasajeros, &idsPasaj[i]);
	}

	for (int i = 0; i < cantPasj; pthread_join(pasajeros[i++], NULL));
	for (int i = 0; i < cantOfi; pthread_join(oficinistas[i++], NULL));

	return 0;
}
