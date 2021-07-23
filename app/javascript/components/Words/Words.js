import React, { useState, useEffect, Fragment } from "react";
import axios from "axios";
import Word from "./Word";
const Words = () => {
  const [words, setWords] = useState([]);

  useEffect(() => {
    axios
      .get("/api/v1/words.json")
      .then((resp) => setWords(resp.data.data))
      .catch((resp) => console.log(resp));
  }, [words.length]);

  const grid = words.map((item) => {
    return <Word key={item.attributes.name} attributes={item.attributes} />;
  });

  return (
    <div className="home">
      <div className="header">
        <h1>JLPT words</h1>
        <div className="subheader">index</div>
      </div>
      <div>this is the index for the app</div>
      {grid}
    </div>
  );
};

export default Words;
