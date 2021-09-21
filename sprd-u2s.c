#include <linux/module.h>
#include <linux/tty.h>
#include <linux/usb.h>
#include <linux/usb/serial.h>

#include "sprd-u2s.h"

static struct usb_device_id sprd_id_table[] = {
	{USB_DEVICE(SPRD_VID, SPRD_PID_DIAG)},
	{}
};

static struct usb_serial_driver sprd_generic_u2s_driver = {
	.driver = {
		.owner = THIS_MODULE,
		.name = "sprd_generic_u2s",
	},
	.num_ports = 1,
	.id_table = sprd_id_table,
};

static struct usb_serial_driver *const sprd_serial_drivers[] = {
	&sprd_generic_u2s_driver,
	NULL
};

static int __init sprd_u2s_init(void)
{
	int ret = 0;

	ret = usb_serial_register_drivers(sprd_serial_drivers, "sprd-u2s", sprd_id_table);
	if (ret)
	{
		pr_err("%s: usb_serial_register_drivers failed, ret = %d\n", __func__, ret);
	}

	return 0;
}

static void __exit sprd_u2s_exit(void)
{
	pr_info("%s: enter\n", __func__);

	usb_serial_deregister_drivers(sprd_serial_drivers);
}

module_init(sprd_u2s_init);
module_exit(sprd_u2s_exit);

MODULE_LICENSE("GPL");
