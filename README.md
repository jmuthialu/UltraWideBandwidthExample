# Sequence of interactions

Note: 
Peer refers to remote device;  Device refers to current device

- Setup session, advertiser and browser
- Peer will send invitation and this will be received by advertiser delegate
- current device accepts invite
- Status changed to .connected
- Device sends token to peer
- Peer sends its token to device
- Gets updates about direction and distance from peer and vice versa.


## Example

advertiser.didReceiveInvitationFromPeer: <MCPeerID: 0x600001354020 DisplayName = iPhone 12>

.connected

connectedToPeer; session?.discoveryToken: <NIDiscoveryToken: 8586E934A02740608F301FB6B48EAD79>

session.didReceiveData

shareMyDiscoveryToken: <NIDiscoveryToken: 8586E934A02740608F301FB6B48EAD79>

dataReceivedHandler.peerDiscoveryToken: <NIDiscoveryToken: D5D6EFFA949F4432883714356A5C781D>

peerDidShareDiscoveryToken: iPhone 12 - <NIDiscoveryToken: D5D6EFFA949F4432883714356A5C781D>

session.didUpdate: Optional(0.16681567) - Optional(SIMD3<Float>(0.18918005, 0.26377103, -0.94585186))