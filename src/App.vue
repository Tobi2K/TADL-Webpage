<template>
  <div id="contact">
    <div>
      <n-button text color="white" @click="showContact = true">
        Contact
      </n-button>
    </div>
  </div>
  <n-modal v-model:show="showContact">
    <n-card
      style="width: 750px"
      title="Contact"
      :bordered="false"
      size="huge"
      role="dialog"
      aria-modal="true"
    >
      This is a private website for a university project. If there are any
      problems, feel free to contact me. <br />
      <br />
      <strong>Tobias Kalmbach</strong> <br />
      +49 1575 0367586 <br />
      <a href="mailto:tobias.kalmbach@uni-ulm.de">Email</a>
    </n-card>
  </n-modal>
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

import { NButton, NModal, NCard } from "naive-ui";

import { ref } from "vue";

export default {
  name: "App",
  components: {
    WelcomeDialog,
    TopicSlider,
    YourParty,
    NButton,
    NModal,
    NCard,
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
      showContact: ref(false),
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

#contact {
  width: 100%;
  top: 0;
  float: right;
  color: white;
  margin-bottom: 60px;
}

#contact div {
  float: right;
  width: fit-content;
  padding: 10px;
}
</style>
