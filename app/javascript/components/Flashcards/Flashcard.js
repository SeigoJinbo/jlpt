import React, { useState } from "react";

export default function Flashcard({ flashcard }) {
  const [flip, setFlip] = useState(false);
  return (
    <div
      className={`card ${flip ? "flip" : ""}`}
      onClick={() => setFlip(!flip)}
    >
      <div className="front">
        {flashcard.name}
        <div className="options">
          {flashcard.options.map((option) => {
            return <div className="option">{option}</div>;
          })}
        </div>
      </div>

      <div className="back">{flashcard.definition}</div>
      {/* {flip ? flashcard.definition : flashcard.name} */}
    </div>
  );
}
