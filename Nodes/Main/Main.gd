extends Node2D

# warning-ignore-all:return_value_discarded

onready var peerList: ItemList = find_node("PeerList")
onready var progressIndicator: AnimatedSprite = find_node("ProgressIndicator")

func _ready():
  Engine.set_target_fps(24)

  if OS.get_model_name() != "GenericDevice":
    find_node("QuitButton").visible = false
    
  PeerFinder.connect("server_started", self, "on_server_started")
  PeerFinder.connect("server_stopped", self, "on_server_stoped")
  PeerFinder.connect("peer_found", self, "on_peer_found_event")
  PeerFinder.connect("peer_lost", self, "on_peer_lost_event")

  # GUI controls
func _on_QuitButton_pressed():
  PeerFinder.stop()
  get_tree().quit()

func _on_DiscoverableButton_toggled(state: bool):
  if state:
    PeerFinder.start()
  else:
    PeerFinder.stop()

# Signals
func on_server_stoped():
  print("Main::on_server_stoped")
  progressIndicator.visible = false
  peerList.clear()

func on_server_started():
  print("Main::on_server_started")
  progressIndicator.visible = true
  peerList.clear()

func on_peer_found_event(event: PeerEventPeerFound):
  var remoteHost = event.peer_address + ":" + str(event.peer_port)
  peerList.add_item(remoteHost)
  peerList.sort_items_by_text()

func on_peer_lost_event(event: PeerEventPeerLost):
  var lostPeer = event.peer_address + ":" + str(event.peer_port)
  
  for i in peerList.get_item_count():
    if peerList.get_item_text(i) == lostPeer:
      peerList.remove_item(i)
  pass
