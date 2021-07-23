import React, { useState } from "react";
import { Route, Switch } from "react-router-dom";
import Words from "./Words/Words";
import Word from "./Word/Word";
import Flashcards from "./Flashcards/Flashcards";
const App = () => {
  return (
    <Switch>
      <Route exact path="/" component={Words} />
      <Route exact path="/words/:slug" component={Word} />
      <Route exact path="/flashcards" component={Flashcards} />
    </Switch>
  );
};

export default App;
