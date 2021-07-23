import React from "react";

const Word = (props) => {
  const def = props.attributes.definition;
  const entries = Object.entries(def);
  console.log(entries[0][1]["type"]);

  const grid = entries.map((item, index) => {
    return (
      <div>
        {index + 1}. {item[1]["type"]}: {item[1]["meaning"]}
      </div>
    );
  });

  const definition = props.attributes.definition["0"]["meaning"];

  return (
    <div className="card">
      <div className="word-name">{props.attributes.name}</div>
      <div className="word-furigana">{props.attributes.furigana}</div>
      <div className="word-kanjis">{grid}</div>
    </div>
  );
};

export default Word;
