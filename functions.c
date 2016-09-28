#include <stdio.h>
#include <math.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>

struct var_node {
	char type[4];
	char name[128];
	struct var_node *next;
};

struct varlist {
	int size;
	struct var_node *head;
} vars = {0, NULL};


void
add_var (
	struct varlist * vl,
	const char * const this_type,
	char * this_name
)
{
	struct var_node * cur_node = (struct var_node *)malloc(sizeof(struct var_node));

	strcpy(cur_node->type, this_type);
	strcpy(cur_node->name, this_name);
	cur_node->next = NULL;

	if (vl->head == NULL)
		vl->head = cur_node;
	else
	{
		struct var_node * cur;
		for (cur = vl->head; cur->next != NULL; cur = cur->next) ;
		cur->next = cur_node;
	}
	vl->size++;
}

int
get_var_type (
	struct varlist *vl,
	char *search_param,
	char *this_type
)
{
	struct var_node *cur = vl -> head;

	for (cur = vl->head ; cur->next != NULL && strcmp(search_param, cur->name) != 0; cur = cur->next) ;

	if (strcmp(cur->name, search_param) != 0)
		return -1;

	strcpy(this_type, cur->type);

	return 0;
}
