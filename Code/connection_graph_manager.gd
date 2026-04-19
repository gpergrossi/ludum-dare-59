# @author Vivian

class_name ConnectionGraphManager extends Resource

var _items: Array[ItemInfo] = []; # Each has item:WireBox and group:Array[WireBox] members.
var _connections: Array[Connection] = []; # Each has from:WireBox and to:WireBox members.
var _groups: Array[Array] = []; # Array[Array[WireBox]]

func add_item(item: WireBox):
	if (has_item(item)): return;

	var itemInfo = ItemInfo.new(item);
	_items.push_back(itemInfo);
	_groups.push_back(itemInfo.group);

func has_item(item: WireBox) -> bool:
	for i in _items:
		if (i.item == item): return true;
	return false;

func connect_items(item1: WireBox, item2: WireBox):
	assert(item1 != item2, "Connecting a WireBox to itself is not supported by ConnectionGraphManager.");
	if (is_directly_connected(item1, item2)): return;

	add_item(item1);
	add_item(item2);

	var connection = Connection.new(item1, item2);
	_connections.push_back(connection);

	_merge_groups(item1, item2);

func is_directly_connected(item1: WireBox, item2: WireBox) -> bool:
	for c in _connections:
		if (c.connects(item1, item2)): return true;
	return false;

func is_connected_including_indirectly(item1: WireBox, item2: WireBox) -> bool:
	add_item(item1);
	add_item(item2);

	var group1 := _get_info(item1).group;
	var group2 := _get_info(item2).group;

	return group1 == group2;

func disconnect_items(item1: WireBox, item2: WireBox):
	assert(item1 != item2, "Connecting (and therefore, disconnecting) a WireBox to itself is not supported by ConnectionGraphManager.");
	if (not is_directly_connected(item1, item2)): return;
	
	_remove_connection(item1, item2);
	if (_are_connected_pathfind(item1, item2)): return;
	_split_group(item1, item2);

func _merge_groups(item1: WireBox, item2: WireBox):
	var group1 := _get_info(item1).group;
	var group2 := _get_info(item2).group;

	if (group1 == group2): return;

	for i in group2:
		var info = _get_info(i);
		info.group = group1;
		group1.push_back(i);
	# All references to group2 should be gone now.

	_groups.erase(group2);

func _get_info(item: WireBox) -> ItemInfo:
	for i in _items:
		if (i.item == item): return i;
	assert(false, "Internal ConnectionGraphManager error: _get_info called for nonexistent WireBox");
	return;

func _remove_connection(item1: WireBox, item2: WireBox):
	for c in _connections:
		if (c.connects(item1, item2)):
			_connections.erase(c); # Mutate during iteration only fine because we return immediately.
			return;

# Returns true if any route exists from item1 to item2, using only the connections data
func _are_connected_pathfind(source: WireBox, destination: WireBox) -> bool:
	var queue = [source];
	var wasEverEnqueued = Set.new([source]);

	while (not queue.is_empty()):
		var item = queue.pop_front();

		var conns = _get_all_connections_from(item);
		for c in conns:
			var otherItem = c.get_other_item(item);
			if (otherItem == destination): return true;

			if (wasEverEnqueued.has(otherItem)): continue;
			wasEverEnqueued.add(otherItem);

			queue.push_back(otherItem);

	return false;

func _split_group(item1: WireBox, item2: WireBox):
	var info1 = _get_info(item1);
	var info2 = _get_info(item2);

	assert(info1.group == info2.group, "Internal ConnectionGraphManager error: Called _split_group on a pair not already in the same group.");

	# Dissolve group
	var group = info1.group;
	
	# Rebuild two new groups via pathfind
	# Handles updating `_groups` and each item info's `.group` value.
	var newGroup1 = _rebuild_group_by_pathfind_from(item1);
	var newGroup2 = _rebuild_group_by_pathfind_from(item2);

	# `group` should now be only remaining reference to its array.
	_groups.erase(group);
	
	# Double check everything got assigned
	for i in group:
		var info = _get_info(i);
		assert(info.group == newGroup1 or info.group == newGroup2, "Internal ConnectionGraphManager error: _split_group failed to assign new group to at least one member item.");

func _rebuild_group_by_pathfind_from(source: WireBox) -> Array: # Returns Array[WireBox]
	var queue = [source];
	var newGroup = Set.new([source]);

	while (not queue.is_empty()):
		var item = queue.pop_front();

		var conns = _get_all_connections_from(item);
		for c in conns:
			var otherItem = c.get_other_item(item);

			if (newGroup.has(otherItem)): continue;
			newGroup.add(otherItem);

			queue.push_back(otherItem);

	# Record the new group in the `_groups` array
	var group = newGroup.toArray();
	_groups.push_back(group);
	
	# Set group on each item's info
	for i in group:
		var info = _get_info(i);
		info.group = group;

	return group;

func _get_all_connections_from(source: WireBox) -> Array[Connection]:
	return _connections.filter(func(c: Connection): return c.involves(source));

class ItemInfo:
	var item: WireBox;
	var group: Array; # Array[WireBox]

	func _init(i: WireBox):
		item = i;
		group = [i];

class Connection:
	var from: WireBox;
	var to: WireBox;
	
	func _init(f: WireBox, t: WireBox):
		from = f;
		to = t;
	
	func connects(item1: WireBox, item2: WireBox) -> bool:
		return (from == item1 and to == item2) or (to == item1 and from == item2);
	
	func involves(item: WireBox) -> bool:
		return (from == item) or (to == item);

	func get_other_item(besides: WireBox) -> WireBox:
		if (from == besides): return to;
		if (to == besides): return from;
		assert(false, "Internal ConnectionGraphManager error: Called Connection.get_other_item for an item it's not actually connecting!");
		return;

class WireBox:
	pass; # Dummy object, placeholder for Greg's Tower/SignalEmitter base class

class Set:
	var _contents := {};

	func _init(items = []):
		for i in items:
			add(i);

	func add(item):
		_contents[item] = true;

	func has(item) -> bool:
		return _contents.has(item);

	func remove(item):
		_contents.erase(item);

	func toArray():
		return _contents.keys();
