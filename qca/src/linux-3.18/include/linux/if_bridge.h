/*
 *	Linux ethernet bridge
 *
 *	Authors:
 *	Lennert Buytenhek		<buytenh@gnu.org>
 *
 *	This program is free software; you can redistribute it and/or
 *	modify it under the terms of the GNU General Public License
 *	as published by the Free Software Foundation; either version
 *	2 of the License, or (at your option) any later version.
 */
#ifndef _LINUX_IF_BRIDGE_H
#define _LINUX_IF_BRIDGE_H


#include <linux/netdevice.h>
#include <uapi/linux/if_bridge.h>
#include <linux/bitops.h>

#define BR_HAIRPIN_MODE		BIT(0)
#define BR_BPDU_GUARD           BIT(1)
#define BR_ROOT_BLOCK		BIT(2)
#define BR_MULTICAST_FAST_LEAVE	BIT(3)
#define BR_ADMIN_COST		BIT(4)
#define BR_LEARNING		BIT(5)
#define BR_FLOOD		BIT(6)
#define BR_AUTO_MASK		(BR_FLOOD | BR_LEARNING)
#define BR_PROMISC		BIT(7)
#define BR_ISOLATE_MODE		BIT(8)
#define BR_MULTICAST_TO_UCAST	BIT(9)
#define BR_PROXYARP		BIT(10)
#define BR_PROXYARP_WIFI	BIT(11)

struct br_ip {
	union {
		__be32	ip4;
#if IS_ENABLED(CONFIG_IPV6)
		struct in6_addr ip6;
#endif
	} u;
	__be16		proto;
	__u16           vid;
};

struct br_ip_list {
	struct list_head list;
	struct br_ip addr;
};

struct net_bridge_port;

extern void brioctl_set(int (*ioctl_hook)(struct net *, unsigned int, void __user *));
extern struct net_device *br_port_dev_get(struct net_device *dev, unsigned char *addr);
extern void br_refresh_fdb_entry(struct net_device *dev, const char *addr);
extern void br_dev_update_stats(struct net_device *dev, struct rtnl_link_stats64 *nlstats);
extern bool br_fdb_has_entry(struct net_device *dev, const char *addr, __u16 vid);
extern void br_fdb_update_register_notify(struct notifier_block *nb);
extern void br_fdb_update_unregister_notify(struct notifier_block *nb);

typedef int br_should_route_hook_t(struct sk_buff *skb);
extern br_should_route_hook_t __rcu *br_should_route_hook;

#if IS_ENABLED(CONFIG_BRIDGE) && IS_ENABLED(CONFIG_BRIDGE_IGMP_SNOOPING)
int br_multicast_list_adjacent(struct net_device *dev,
			       struct list_head *br_ip_list);
bool br_multicast_has_querier_anywhere(struct net_device *dev, int proto);
bool br_multicast_has_querier_adjacent(struct net_device *dev, int proto);
#else
static inline int br_multicast_list_adjacent(struct net_device *dev,
					     struct list_head *br_ip_list)
{
	return 0;
}
static inline bool br_multicast_has_querier_anywhere(struct net_device *dev,
						     int proto)
{
	return false;
}
static inline bool br_multicast_has_querier_adjacent(struct net_device *dev,
						     int proto)
{
	return false;
}
#endif

typedef int (br_multicast_handle_hook_t)(const struct net_bridge_port *src,
		struct sk_buff *skb);
extern br_multicast_handle_hook_t __rcu *br_multicast_handle_hook;

#define BR_FDB_EVENT_ADD     0x01
#define BR_FDB_EVENT_DEL     0x02
struct br_fdb_event {
	struct net_device *dev;
	unsigned char      addr[6];
	unsigned char      is_local;
};
extern void br_fdb_register_notify(struct notifier_block *nb);
extern void br_fdb_unregister_notify(struct notifier_block *nb);
#endif
