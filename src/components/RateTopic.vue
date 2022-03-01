<template>
  <n-space vertical>
    <h1>{{ info.value }}</h1>
    <n-grid x-gap="12" :cols="party_mixed.length">
      <n-gi
        v-for="(party, index) in party_mixed"
        :key="party.value"
        :value="party.value"
      >
        <n-card :title="'Party #' + (index + 1)" style="height: 100%">
          <p>{{ party.text }}</p>
          <template #action>
            <n-rate
              :on-update:value="(value) => updateRating(value, party.id)"
            />
          </template>
        </n-card>
      </n-gi>
    </n-grid>
  </n-space>
</template>

<script>
import { defineComponent, ref } from "vue";

import { NSpace, NCard, NGrid, NGi, NRate } from "naive-ui";

export default defineComponent({
  name: "RateTopic",
  props: {
    info: Object,
  },
  components: {
    NSpace,
    NCard,
    NGrid,
    NGi,
    NRate,
  },
  emits: ["updatePoints"],
  data() {
    return {
      points: [],
    };
  },
  setup(props) {
    const party_mixed = props.info.parties
      .map((value) => ({ value, sort: Math.random() }))
      .sort((a, b) => a.sort - b.sort)
      .map(({ value }) => value);
    return {
      party_mixed,
      party: ref(null),
      topic: ref(null),
    };
  },
  methods: {
    updateRating(value, partyID) {
      this.points[partyID] = value;
      this.$emit("updatePoints", this.info.id, this.points);
    },
  },
});
</script>
