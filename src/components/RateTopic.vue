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
          <div @click="openModal(index + 1, party.text)">
            <n-ellipsis :line-clamp="15" :tooltip="false">
              {{ party.text }}
            </n-ellipsis>
          </div>

          <template #action>
            <n-rate
              :on-update:value="(value) => updateRating(value, party.id)"
            />
          </template>
        </n-card>
      </n-gi>
    </n-grid>
    <n-modal v-model:show="showModal">
      <n-card
        style="width: 50%"
        :title="info.value"
        :bordered="false"
        size="huge"
        aria-modal="true"
      >
        <template #header-extra>Party #{{ modalTitle }} </template>
        {{ modalText }}
      </n-card>
    </n-modal>
  </n-space>
</template>

<script>
import { defineComponent, ref } from "vue";

import { NSpace, NCard, NGrid, NGi, NRate, NEllipsis, NModal } from "naive-ui";

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
    NEllipsis,
    NModal,
  },
  emits: ["updatePoints"],
  data() {
    return {
      points: [],
      modalTitle: "",
      modalText: "",
    };
  },
  setup(props) {
    const party_mixed = props.info.parties
      .map((value) => ({ value, sort: Math.random() }))
      .sort((a, b) => a.sort - b.sort)
      .map(({ value }) => value);
    return {
      party_mixed,
      showModal: ref(false),
    };
  },
  methods: {
    updateRating(value, partyID) {
      this.points[partyID] = value;
      this.$emit("updatePoints", this.info.id, this.points);
    },
    openModal(index, text) {
      this.modalTitle = index;
      this.modalText = text;
      this.showModal = true;
    },
  },
});
</script>
