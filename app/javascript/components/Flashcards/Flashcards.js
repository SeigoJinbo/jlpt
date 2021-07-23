const { refreshCSRFTokens } = require("@rails/ujs");

import React, { useState } from "react";
import Flashcard from "./Flashcard";
const SAMPLE_FLASHCARDS = [
  {
    id: 1,
    name: "kanji 1",
    definition: "meaning 1",
    options: ["1", "2", "3", "4"],
  },
  {
    id: 2,
    name: "kanji 2",
    definition: "meaning 2",
    options: ["1", "2", "3", "4"],
  },
  {
    id: 3,
    name: "kanji 3",
    definition: "meaning 3",
    options: ["1", "2", "3", "4"],
  },
];

export default function Flashcards() {
  const [flashcards, setFlashcards] = useState(SAMPLE_FLASHCARDS);

  const grid = flashcards.map((item) => {
    return <Flashcard flashcard={item} key={item.id} />;
  });
  return (
    <div className="card-grid">
      <h1>title</h1>
      {grid}
    </div>
  );
}
