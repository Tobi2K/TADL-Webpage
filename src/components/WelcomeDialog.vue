<template>
  <div class="container">
    <n-card
      size="huge"
      :bordered="false"
      style="background: rgba(255, 255, 255, 0.4); width: 60%; margin-left: 20%"
    >
      <h1>WELCOME TO OUR PROJECT</h1>
      <h2>Semi-automatic evaluation of German partymanifestos</h2>
      <h3>What?</h3>
      <p>
        This Application lets you rate statements made by German political
        parties, without knowing who actually said what. In the end, you get a
        ranking of which partys statements you most agree with.
      </p>
      <h3>Why?</h3>
      <p>
        This project aims to extract information from party manifestos on
        certain topics. We hope to give a good insight into party talking points
        without needing to read the entire manifesto.
      </p>
      <h3>How?</h3>
      <p>
        To get started click the button below and rate all statements with 1-5
        stars. You can navigate between topics using the arrows at the bottom of
        the page.
      </p>
      <n-button type="info" :round="true" @click="this.$emit('start')"
        >Start</n-button
      >
      <p>
        <small>
          Important Note: The party manifestos are written in German. Thus the
          following pages will be German.
        </small>
      </p>
    </n-card>
  </div>
</template>

<script>
import { NButton, NCard } from "naive-ui";

export default {
  name: "WelcomeDialog",
  components: {
    NButton,
    NCard,
  },
  emits: ["start"],
};
</script>
