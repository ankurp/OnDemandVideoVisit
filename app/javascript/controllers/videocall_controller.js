import { Controller } from 'stimulus'; 
import { connect, createLocalTracks } from 'twilio-video';
import { visit } from '@hotwired/turbo';

export default class VideoCallController extends Controller {
  static values = { accessToken: String, roomName: String }

  connect() {
    createLocalTracks({
      audio: true,
      video: { width: 640 }
    })
    .then(this.onLocalTrackConnect.bind(this));

    window.addEventListener('unload', this.disconnect.bind(this));
  }

  toggleAudio() {
    if (!this.room) return;

    this.room.localParticipant.audioTracks.forEach(publication => {
      publication.track.disable();
    });
  }
  
  toggleVideo() {
    if (!this.room) return;

    this.room.localParticipant.videoTracks.forEach(publication => {
      publication.track.disable();
    });  
  }

  disconnect() {
    window.removeEventListener('unload', this.disconnect.bind(this));
    if (this.room) {
      this.room.localParticipant.videoTracks.forEach(publication => {
        publication.track.stop();
        publication.unpublish();
      });
      this.room.disconnect();
      visit('/');
    }
  }

  onLocalTrackConnect(localTracks) {
    const localMediaContainer = document.getElementById('local-media');
    localTracks.forEach(track => {
      localMediaContainer.appendChild(track.attach());
    });
    this.connectToRoom(localTracks);
  }

  handleTrackEnableDisable(track) {
    track.on('enabled', () => {
      this.attachTrackToDom(track);
    });
    track.on('disabled', () => {
      this.removeTrackFromDom(track);
    });
  }

  onParticipantConnected(participant) {
    this.getTracksFromParticipant(participant)
      .forEach(publication => {
        if (publication.track) {
          this.attachTrackToDom(publication.track);
        }

        if (publication.isSubscribed) {
          this.handleTrackEnableDisable(publication.track);
        }
        publication.on('subscribed', this.handleTrackEnableDisable.bind(this));
        publication.on('unsubscribed', this.handleTrackEnableDisable.bind(this));  
      });
      participant.on('trackSubscribed', this.attachTrackToDom.bind(this));
      participant.on('trackUnsubscribed', this.removeTrackFromDom.bind(this));
  }

  getTracksFromParticipant(participant) {
    return Array.from(participant.tracks.values())
      .filter(publication => publication.track)
      .map(publication => publication.track);
  }

  onParticipantDisconnected(participant) {
    this.getTracksFromParticipant(participant)
      .forEach(this.removeTrackFromDom.bind(this));
  }

  attachTrackToDom(track) {
    document.getElementById('remote-media-div').prepend(track.attach());
  }

  removeTrackFromDom(track) {
    const attachedElements = track.detach();
    attachedElements.forEach(element => element.remove());
  }

  onConnected(room) {
    this.room = room;
    room.on('participantConnected', this.onParticipantConnected.bind(this));
    room.on('participantDisconnected', this.onParticipantDisconnected.bind(this));
    room.participants.forEach(this.onParticipantConnected.bind(this));
    room.on('disconnected', this.onDisconnect.bind(this));
  }

  handleTrackDisabled(track) {
    track.on('disabled', () => {
      /* Hide the associated <video> element and show an avatar image. */
    });
  }

  connectToRoom(localTracks) {
    connect(this.accessTokenValue, {
      name: this.roomNameValue,
      tracks: localTracks,
    })
    .then(this.onConnected.bind(this), error => {
      window.alert('Error connecting to video call');
    });
  }

  onDisconnect(room) {
    room.localParticipant.tracks.forEach(publication => {
      this.removeTrackFromDom(publication.track);
    });
  }
}
