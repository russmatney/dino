class_name ActiveQuest
extends Node

var label: String
var complete: bool = false
var failed: bool = false
var node: Node

var remaining: int
var total: int
var optional: bool
var check_not_failed: bool