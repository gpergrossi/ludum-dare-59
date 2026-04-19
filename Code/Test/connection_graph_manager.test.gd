class_name ConnectionGraphManagerTest extends Node

func _ready():
	run_all_tests();

func run_all_tests():
	print("Running ConnectionGraphManager tests...")
	_basic_smoke_test();
	_split_groups_test();
	_multiply_connected_groups_do_not_split_test();
	print("All ConnectionGraphManager tests pass.")

func assert_crash_on_fail(condition: bool, message: String = ""):
	if (condition): return;
	
	if (not message.is_empty()): push_error(message);
	get_tree().quit(1);

const WireBox = ConnectionGraphManager.WireBox;

func _basic_smoke_test():
	var manager = ConnectionGraphManager.new();
	
	var item1 = WireBox.new();
	var item2 = WireBox.new();

	manager.add_item(item1);
	assert_crash_on_fail(manager.has_item(item1), "Failed to add (or report has) item.");
	
	assert_crash_on_fail(not manager.has_item(item2), "Erroneously reporting has item before adding it.");
	manager.add_item(item2);
	assert_crash_on_fail(manager.has_item(item2), "Failed to add (or report has) item.");
	
	assert_crash_on_fail(not manager.is_directly_connected(item1, item2), "Erroneously reporting direct connection before actually connecting items.");
	assert_crash_on_fail(not manager.is_connected_including_indirectly(item1, item2), "Erroneously reporting indirect connection before actually connecting items.");
	manager.connect_items(item1, item2);
	assert_crash_on_fail(manager.is_directly_connected(item1, item2), "Failed to report direct connection.");
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item2), "Failed to report indirect connection when items are directly connected.");
	
	manager.disconnect_items(item1, item2);
	assert_crash_on_fail(manager.has_item(item1));
	assert_crash_on_fail(manager.has_item(item2));
	assert_crash_on_fail(not manager.is_directly_connected(item1, item2));
	assert_crash_on_fail(not manager.is_connected_including_indirectly(item1, item2));
	
	var item3 = WireBox.new();
	
	assert_crash_on_fail(not manager.has_item(item3));
	manager.add_item(item3);
	assert_crash_on_fail(manager.has_item(item3));
	
	manager.connect_items(item1, item2);
	manager.connect_items(item2, item3);
	assert_crash_on_fail(not manager.is_directly_connected(item1, item3));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item3));
	
	print("_basic_smoke_test passed.");

func _split_groups_test():
	var manager = ConnectionGraphManager.new();
	
	var item1 = WireBox.new();
	var item2 = WireBox.new();
	var item3 = WireBox.new();
	var item4 = WireBox.new();
	
	manager.add_item(item1);
	manager.add_item(item2);
	manager.add_item(item3);
	manager.add_item(item4);
	
	manager.connect_items(item1, item2);
	manager.connect_items(item2, item3);
	manager.connect_items(item3, item4);
	
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item2));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item3));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item4));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item2, item3));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item2, item4));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item3, item4));
	
	manager.disconnect_items(item2, item3);
	
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item2));
	assert_crash_on_fail(not manager.is_connected_including_indirectly(item1, item3));
	assert_crash_on_fail(not manager.is_connected_including_indirectly(item1, item4));
	assert_crash_on_fail(not manager.is_connected_including_indirectly(item2, item3));
	assert_crash_on_fail(not manager.is_connected_including_indirectly(item2, item4));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item3, item4));
	
	print("_split_groups_test passed.");

func _multiply_connected_groups_do_not_split_test():
	
	var manager = ConnectionGraphManager.new();
	
	var item1 = WireBox.new();
	var item2 = WireBox.new();
	var item3 = WireBox.new();
	var item4 = WireBox.new();
	
	manager.add_item(item1);
	manager.add_item(item2);
	manager.add_item(item3);
	manager.add_item(item4);
	
	manager.connect_items(item1, item2);
	manager.connect_items(item2, item3);
	manager.connect_items(item3, item4);
	manager.connect_items(item1, item4);
	
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item2));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item3));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item4));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item2, item3));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item2, item4));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item3, item4));
	
	manager.disconnect_items(item2, item3);
	
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item2));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item3));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item1, item4));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item2, item3));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item2, item4));
	assert_crash_on_fail(manager.is_connected_including_indirectly(item3, item4));
	
	print("_multiply_connected_groups_do_not_split_test passed.");
