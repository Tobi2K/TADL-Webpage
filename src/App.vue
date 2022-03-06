<template>
  <welcome-dialog @start="start()" v-if="info" />
  <div class="container" v-else>
    <topic-slider
      v-if="selecting"
      :topics="topics"
      @calculateScore="calculateScore"
      @updatePoints="updateScores"
      :key="refresh"
      :showParty="showParty"
    />
    <your-party v-else :result="result" @reset="reset" />
  </div>
</template>

<script>
import WelcomeDialog from "./components/WelcomeDialog.vue";
import TopicSlider from "./components/TopicSlider.vue";
import YourParty from "./components/YourParty.vue";

export default {
  name: "App",
  components: {
    WelcomeDialog,
    TopicSlider,
    YourParty,
  },
  data() {
    return {
      score: [],
      result: [],
      selecting: true,
      refresh: false,
      selectedPartyID: null,
      info: true,
      showParty: false,
    };
  },
  setup() {
    const topics = require("./assets/summaries.json");
    return {
      parties: [
        "Alternative für Deutschland",
        "Christlich Demokratische Union Deutschlands",
        "Freie Demokratische Partei",
        "Bündnis 90/Die Grünen",
        "Die Linke",
        "Sozialdemokratische Partei Deutschlands",
      ],
      topics,
    };
  },
  methods: {
    updateScores(infoID, points) {
      this.score[infoID] = points;
    },
    calculateScore() {
      for (let i = 0; i < this.parties.length; i++) {
        const x = {
          score: 0,
          name: this.parties[i],
        };
        this.result[i] = x;
      }
      for (let i = 0; i < this.score.length; i++) {
        const element = this.score[i];
        if (!element) continue;
        for (let j = 0; j < element.length; j++) {
          const el = element[j];
          if (el != undefined) this.result[j].score += Number(el);
        }
      }
      this.result = this.result.sort((a, b) => b.score - a.score);
      this.selecting = false;
    },
    reset(showParty) {
      this.refresh = !this.refresh;
      this.score = [];
      this.result = [];
      this.selecting = true;
      this.showParty = showParty;
    },
    start() {
      this.info = false;
    },
  },
};
</script>

<style>
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
.mt {
  margin-top: 3%;
}
.mb {
  margin-bottom: 3%;
}
.container {
  width: 90%;
  margin-left: 5%;
}
html {
  min-height: 100%;
  background: rgb(255, 120, 62);

  background: linear-gradient(135deg, #ff783e 0%, #ad6098 100%);
}
</style>
