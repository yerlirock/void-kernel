/*
 * Author: andip71, 21.04.2013
 *         arter97 (earlysuspend), 08.12.2013
 *
 * This software is licensed under the terms of the GNU General Public
 * License version 2, as published by the Free Software Foundation, and
 * may be copied, distributed, and modified under those terms.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 */

#include <linux/earlysuspend.h>
#include <linux/ioctl.h>
#include <linux/kobject.h>
#include <linux/sysfs.h>
#include <linux/syscalls.h>
#include "logger_interface.h"

/*
 * logger_mode
 *
 * 0 : disable writing to Android logcat
 * 1 :  enable writing to Android logcat
 * 2 :  enable writing to Android logcat and clear(flush) on earlysuspend
 * 3 :  enable writing to Android logcat but disable & clear(flush) on earlysuspend and re-enable on resume
 *
 */
int logger_mode;
bool early_suspend_logger_mode = false;

/* sysfs interface for logger mode */

static ssize_t logger_mode_show(struct kobject *kobj, struct kobj_attribute *attr, char *buf)
{
	// print current mode
	switch (logger_mode) {
		case 0:
			if (early_suspend_logger_mode)
				return sprintf(buf, "logger mode: 3 (enabled but disable & clear on earlysuspend)\n");
			else
				return sprintf(buf, "logger mode: %d (disabled)\n", logger_mode);
			break;
		case 1:
			return sprintf(buf, "logger mode: %d (enabled)\n", logger_mode);
			break;
		case 2:
			return sprintf(buf, "logger mode: %d (enabled and clear on earlysuspend)\n", logger_mode);
			break;
		case 3:
			return sprintf(buf, "logger mode: %d (enabled but disable & clear on earlysuspend)\n", logger_mode);
			break;
		default:
			return sprintf(buf, "unable to read logger mode\n");
	}
}

static ssize_t logger_mode_store(struct kobject *kobj, struct kobj_attribute *attr, const char *buf, size_t count)
{
	unsigned int ret = -EINVAL;
	int val;

	// read value from input buffer
	ret = sscanf(buf, "%d", &val);

	// check value and store if valid
	if ((val == 0) || (val == 1) || (val == 2) || (val == 3))
	{
		logger_mode = val;
	}

	return count;
}

static void logger_early_suspend(struct early_suspend *handler)
{
	if ((logger_mode == 2) || (logger_mode == 3)) {
		pr_info("%s: flushing Android logcat\n", __func__);
		sys_ioctl(sys_open("/dev/log/events",	O_RDWR | O_NDELAY, 0), _IO(0xAE, 4), 0);
		sys_ioctl(sys_open("/dev/log/main",	O_RDWR | O_NDELAY, 0), _IO(0xAE, 4), 0);
		sys_ioctl(sys_open("/dev/log/radio",	O_RDWR | O_NDELAY, 0), _IO(0xAE, 4), 0);
		sys_ioctl(sys_open("/dev/log/system",	O_RDWR | O_NDELAY, 0), _IO(0xAE, 4), 0);
	}
	if (logger_mode == 3) {
		pr_info("%s: disabling Android logcat\n", __func__);
		early_suspend_logger_mode = true;
		logger_mode = 0;
	}
}

static void logger_late_resume(struct early_suspend *handler)
{
	if ((logger_mode == 0) && early_suspend_logger_mode) {
		pr_info("%s: re-enabling Android logcat\n", __func__);
		early_suspend_logger_mode = false;
		logger_mode = 3;
	}
}

static struct early_suspend logger_suspend = {
	.suspend = logger_early_suspend,
	.resume = logger_late_resume,
};

/* Initialize logger_mode sysfs folder */

static struct kobj_attribute logger_mode_attribute =
	__ATTR(logger_mode, 0666, logger_mode_show, logger_mode_store);

static struct attribute *logger_mode_attrs[] = {
	&logger_mode_attribute.attr,
	NULL,
};

static struct attribute_group logger_mode_attr_group = {
	.attrs = logger_mode_attrs,
};

static struct kobject *logger_mode_kobj;

int logger_mode_init(void)
{
	int logger_mode_retval;

	logger_mode_kobj = kobject_create_and_add("logger_mode", kernel_kobj);

	if (!logger_mode_kobj) {
		return -ENOMEM;
	}

	logger_mode_retval = sysfs_create_group(logger_mode_kobj, &logger_mode_attr_group);

	if (logger_mode_retval)
	{
		kobject_put(logger_mode_kobj);
	}

	// initialize logger mode to 1 (enabled) as default
	logger_mode = 1;

	// register early_suspend for logger_mode = 2
	register_early_suspend(&logger_suspend);

	return (logger_mode_retval);
}


void logger_mode_exit(void)
{
	kobject_put(logger_mode_kobj);
}

/* define driver entry points */
module_init(logger_mode_init);
module_exit(logger_mode_exit);
