import Buffer "mo:base/Buffer";
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Time "mo:base/Time";

actor {
  type NoteId = Nat;
  
  type Note = {
    id : NoteId;
    title : Text;
    content : Text;
    tags : [Text];
    created : Time.Time;
    updated : Time.Time;
  };

  var notes = Buffer.Buffer<Note>(0);

  public func createNote(title : Text, content : Text, tags : [Text]) : async NoteId {
    let noteId = notes.size();
    let currentTime = Time.now();
    let newNote : Note = {
      id = noteId;
      title = title;
      content = content;
      tags = tags;
      created = currentTime;
      updated = currentTime;
    };
    notes.add(newNote);
    noteId;
  };

  public query func getNote(noteId : NoteId) : async ?Note {
    if (noteId < notes.size()) {
      ?notes.get(noteId);
    } else {
      null;
    };
  };

  public func updateNote(noteId : NoteId, title : Text, content : Text, tags : [Text]) : async Bool {
    if (noteId < notes.size()) {
      let note = notes.get(noteId);
      let updatedNote : Note = {
        id = note.id;
        title = title;
        content = content;
        tags = tags;
        created = note.created;
        updated = Time.now();
      };
      notes.put(noteId, updatedNote);
      true;
    } else {
      false;
    };
  };

  public query func getAllNotes() : async [Note] {
    Buffer.toArray(notes);
  };

  public query func searchNotesByTag(tag : Text) : async [Note] {
    let results = Buffer.Buffer<Note>(0);
    for (note in notes.vals()) {
      for (t in note.tags.vals()) {
        if (Text.equal(t, tag)) {
          results.add(note);
        };
      };
    };
    Buffer.toArray(results);
  };

  public query func searchNotesByTitle(searchTitle : Text) : async [Note] {
    let results = Buffer.Buffer<Note>(0);
    for (note in notes.vals()) {
      if (Text.equal(note.title, searchTitle)) {
        results.add(note);
      };
    };
    Buffer.toArray(results);
  };
};