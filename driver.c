#include </lib/modules/3.16.0-4-amd64/source/include/linux/module.h>       // for all modules
#include </lib/modules/3.16.0-4-amd64/source/include/linuxlinux/init.h>         // for entry/exit macros
 


int ex01_simple_module_init(void) {

	printk(KERN_ALERT"inside the %s module function\n",_FUNCTION_);
	return 0;
}


void ex01_simple_module_exit(void) {

	
	printk(KERN_ALERT"inside the %s module function\n",_FUNCTION_);

}

module_init(ex01_simple_module_init);
module_exit(ex01_simple_module_exit);
