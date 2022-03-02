<template>
  <div class="container" v-if="info">
    <n-card
      title="WELCOME TO OUR PROJECT"
      size="huge"
      :bordered="false"
      style="background: rgba(255, 255, 255, 0.4); width: 60%; margin-left: 20%"
    >
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
      <n-button type="info" round="true" @click="start()">Start</n-button>
      <p>
        <small
          >Important Note: The party manifestos are written in German. Thus the
          summaries will be German as well.</small
        >
      </p>
    </n-card>
  </div>
  <div class="container" v-else>
    <n-carousel
      show-arrow
      :show-dots="false"
      :loop="false"
      v-if="selecting"
      :key="refresh"
    >
      <rate-topic
        v-for="topic in topics"
        :key="topic"
        :info="topic"
        @updatePoints="updateScores"
      ></rate-topic>
      <template #arrow="{ prev, next, currentIndex }">
        <n-grid :cols="2" x-gap="12" class="mt mb">
          <n-gi>
            <n-button round secondary @click="prev" v-if="currentIndex > 0">
              <n-icon color="white" size="30"><ArrowBackFilled /></n-icon>
            </n-button>
          </n-gi>
          <n-gi>
            <n-button
              round
              secondary
              @click="next"
              v-if="currentIndex < topics.length - 1"
            >
              <n-icon color="white" size="30"><ArrowForwardFilled /></n-icon>
            </n-button>
            <n-button round type="info" @click="calculateScore()" v-else>
              Get Results
            </n-button>
          </n-gi>
        </n-grid>
      </template>
      <template #dots="{ total, currentIndex, to }">
        <ul class="custom-dots">
          <li
            v-for="index of total"
            :key="index"
            :class="{ ['is-active']: currentIndex === index - 1 }"
            @click="to(index - 1)"
          />
        </ul>
      </template>
    </n-carousel>
    <n-card title="YOUR PARTY" size="huge" v-else
      ><h3>
        According to your scores, you agree most with: {{ this.result[0].name }}
      </h3>
      <n-table :bordered="false" :single-line="false">
        <thead>
          <tr>
            <th>Party</th>
            <th>Score</th>
          </tr>
        </thead>
        <tbody>
          <tr v-for="party in result" :key="party">
            <td>{{ party.name }}</td>
            <td>{{ party.score }}</td>
          </tr>
        </tbody>
      </n-table>
      <n-button round secondary type="primary" @click="reset()" class="mt">
        Redo?
      </n-button>
    </n-card>
  </div>
</template>

<script>
import RateTopic from "./components/RateTopic.vue";
import { NCarousel, NGrid, NIcon, NGi, NButton, NCard, NTable } from "naive-ui";
import { ArrowBackFilled, ArrowForwardFilled } from "@vicons/material";

export default {
  name: "App",
  components: {
    RateTopic,
    NCarousel,
    NGrid,
    NIcon,
    ArrowForwardFilled,
    ArrowBackFilled,
    NGi,
    NButton,
    NCard,
    NTable,
  },
  data() {
    return {
      score: [],
      result: [],
      selecting: true,
      refresh: false,
      selectedPartyID: null,
      info: true,
    };
  },
  setup() {
    return {
      parties: [
        "Alternative für Deutschland",
        "Christlich Demokratische Union Deutschlands",
        "Freie Demokratische Partei",
        "Bündnis 90/Die Grünen",
        "Die Linke",
        "Sozialdemokratische Partei Deutschlands",
      ],
      topics: [
        {
          value: "UMWELT",
          id: 0,
          parties: [
            {
              id: 0,
              name: "AFD",
              text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            },
            {
              id: 1,
              name: "CDU",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 2,
              name: "FDP",
              text: "Morbi leo urna molestie at elementum eu. Nunc mi ipsum faucibus vitae. Nunc mi ipsum faucibus vitae aliquet. Senectus et netus et malesuada fames ac turpis egestas. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Sapien pellentesque habitant morbi tristique senectus. Nunc consequat interdum varius sit amet. Maecenas ultricies mi eget mauris pharetra. Viverra nam libero justo laoreet sit amet cursus. Duis convallis convallis tellus id interdum velit. Amet risus nullam eget felis eget nunc lobortis mattis aliquam. Metus vulputate eu scelerisque felis.",
            },
            {
              id: 3,
              name: "GRUENE",
              text: "Molestie at elementum eu facilisis. Pellentesque elit eget gravida cum sociis natoque. At auctor urna nunc id cursus metus aliquam. Malesuada bibendum arcu vitae elementum curabitur vitae nunc sed. Neque aliquam vestibulum morbi blandit cursus risus at ultrices mi. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant. Nunc consequat interdum varius sit amet mattis vulputate enim. Vel turpis nunc eget lorem dolor sed viverra. Nunc non blandit massa enim. Quam pellentesque nec nam aliquam sem et tortor consequat. In hac habitasse platea dictumst quisque. Sit amet mattis vulputate enim nulla aliquet porttitor lacus luctus. Augue neque gravida in fermentum et sollicitudin ac orci.",
            },
            {
              id: 4,
              name: "LINKE",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 5,
              name: "SPD",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
          ],
        },
        {
          value: "WIRTSCHAFT",
          id: 1,
          parties: [
            {
              id: 0,
              name: "AFD",
              text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            },
            {
              id: 1,
              name: "CDU",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 2,
              name: "FDP",
              text: "Morbi leo urna molestie at elementum eu. Nunc mi ipsum faucibus vitae. Nunc mi ipsum faucibus vitae aliquet. Senectus et netus et malesuada fames ac turpis egestas. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Sapien pellentesque habitant morbi tristique senectus. Nunc consequat interdum varius sit amet. Maecenas ultricies mi eget mauris pharetra. Viverra nam libero justo laoreet sit amet cursus. Duis convallis convallis tellus id interdum velit. Amet risus nullam eget felis eget nunc lobortis mattis aliquam. Metus vulputate eu scelerisque felis.",
            },
            {
              id: 3,
              name: "GRUENE",
              text: "Molestie at elementum eu facilisis. Pellentesque elit eget gravida cum sociis natoque. At auctor urna nunc id cursus metus aliquam. Malesuada bibendum arcu vitae elementum curabitur vitae nunc sed. Neque aliquam vestibulum morbi blandit cursus risus at ultrices mi. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant. Nunc consequat interdum varius sit amet mattis vulputate enim. Vel turpis nunc eget lorem dolor sed viverra. Nunc non blandit massa enim. Quam pellentesque nec nam aliquam sem et tortor consequat. In hac habitasse platea dictumst quisque. Sit amet mattis vulputate enim nulla aliquet porttitor lacus luctus. Augue neque gravida in fermentum et sollicitudin ac orci.",
            },
            {
              id: 4,
              name: "LINKE",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 5,
              name: "SPD",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
          ],
        },
        {
          value: "BILDUNG",
          id: 2,
          parties: [
            {
              id: 0,
              name: "AFD",
              text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            },
            {
              id: 1,
              name: "CDU",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 2,
              name: "FDP",
              text: "Morbi leo urna molestie at elementum eu. Nunc mi ipsum faucibus vitae. Nunc mi ipsum faucibus vitae aliquet. Senectus et netus et malesuada fames ac turpis egestas. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Sapien pellentesque habitant morbi tristique senectus. Nunc consequat interdum varius sit amet. Maecenas ultricies mi eget mauris pharetra. Viverra nam libero justo laoreet sit amet cursus. Duis convallis convallis tellus id interdum velit. Amet risus nullam eget felis eget nunc lobortis mattis aliquam. Metus vulputate eu scelerisque felis.",
            },
            {
              id: 3,
              name: "GRUENE",
              text: "Molestie at elementum eu facilisis. Pellentesque elit eget gravida cum sociis natoque. At auctor urna nunc id cursus metus aliquam. Malesuada bibendum arcu vitae elementum curabitur vitae nunc sed. Neque aliquam vestibulum morbi blandit cursus risus at ultrices mi. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant. Nunc consequat interdum varius sit amet mattis vulputate enim. Vel turpis nunc eget lorem dolor sed viverra. Nunc non blandit massa enim. Quam pellentesque nec nam aliquam sem et tortor consequat. In hac habitasse platea dictumst quisque. Sit amet mattis vulputate enim nulla aliquet porttitor lacus luctus. Augue neque gravida in fermentum et sollicitudin ac orci.",
            },
            {
              id: 4,
              name: "LINKE",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 5,
              name: "SPD",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
          ],
        },
        {
          value: "GESELLSCHAFT",
          id: 3,
          parties: [
            {
              id: 0,
              name: "AFD",
              text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            },
            {
              id: 1,
              name: "CDU",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 2,
              name: "FDP",
              text: "Morbi leo urna molestie at elementum eu. Nunc mi ipsum faucibus vitae. Nunc mi ipsum faucibus vitae aliquet. Senectus et netus et malesuada fames ac turpis egestas. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Sapien pellentesque habitant morbi tristique senectus. Nunc consequat interdum varius sit amet. Maecenas ultricies mi eget mauris pharetra. Viverra nam libero justo laoreet sit amet cursus. Duis convallis convallis tellus id interdum velit. Amet risus nullam eget felis eget nunc lobortis mattis aliquam. Metus vulputate eu scelerisque felis.",
            },
            {
              id: 3,
              name: "GRUENE",
              text: "Molestie at elementum eu facilisis. Pellentesque elit eget gravida cum sociis natoque. At auctor urna nunc id cursus metus aliquam. Malesuada bibendum arcu vitae elementum curabitur vitae nunc sed. Neque aliquam vestibulum morbi blandit cursus risus at ultrices mi. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant. Nunc consequat interdum varius sit amet mattis vulputate enim. Vel turpis nunc eget lorem dolor sed viverra. Nunc non blandit massa enim. Quam pellentesque nec nam aliquam sem et tortor consequat. In hac habitasse platea dictumst quisque. Sit amet mattis vulputate enim nulla aliquet porttitor lacus luctus. Augue neque gravida in fermentum et sollicitudin ac orci.",
            },
            {
              id: 4,
              name: "LINKE",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 5,
              name: "SPD",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
          ],
        },
        {
          value: "INNEN",
          id: 4,
          parties: [
            {
              id: 0,
              name: "AFD",
              text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            },
            {
              id: 1,
              name: "CDU",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 2,
              name: "FDP",
              text: "Morbi leo urna molestie at elementum eu. Nunc mi ipsum faucibus vitae. Nunc mi ipsum faucibus vitae aliquet. Senectus et netus et malesuada fames ac turpis egestas. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Sapien pellentesque habitant morbi tristique senectus. Nunc consequat interdum varius sit amet. Maecenas ultricies mi eget mauris pharetra. Viverra nam libero justo laoreet sit amet cursus. Duis convallis convallis tellus id interdum velit. Amet risus nullam eget felis eget nunc lobortis mattis aliquam. Metus vulputate eu scelerisque felis.",
            },
            {
              id: 3,
              name: "GRUENE",
              text: "Molestie at elementum eu facilisis. Pellentesque elit eget gravida cum sociis natoque. At auctor urna nunc id cursus metus aliquam. Malesuada bibendum arcu vitae elementum curabitur vitae nunc sed. Neque aliquam vestibulum morbi blandit cursus risus at ultrices mi. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant. Nunc consequat interdum varius sit amet mattis vulputate enim. Vel turpis nunc eget lorem dolor sed viverra. Nunc non blandit massa enim. Quam pellentesque nec nam aliquam sem et tortor consequat. In hac habitasse platea dictumst quisque. Sit amet mattis vulputate enim nulla aliquet porttitor lacus luctus. Augue neque gravida in fermentum et sollicitudin ac orci.",
            },
            {
              id: 4,
              name: "LINKE",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 5,
              name: "SPD",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
          ],
        },
        {
          value: "ARBEIT UND SOZIALES",
          id: 5,
          parties: [
            {
              id: 0,
              name: "AFD",
              text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
            },
            {
              id: 1,
              name: "CDU",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 2,
              name: "FDP",
              text: "Morbi leo urna molestie at elementum eu. Nunc mi ipsum faucibus vitae. Nunc mi ipsum faucibus vitae aliquet. Senectus et netus et malesuada fames ac turpis egestas. Et ligula ullamcorper malesuada proin libero nunc consequat interdum. Sapien pellentesque habitant morbi tristique senectus. Nunc consequat interdum varius sit amet. Maecenas ultricies mi eget mauris pharetra. Viverra nam libero justo laoreet sit amet cursus. Duis convallis convallis tellus id interdum velit. Amet risus nullam eget felis eget nunc lobortis mattis aliquam. Metus vulputate eu scelerisque felis.",
            },
            {
              id: 3,
              name: "GRUENE",
              text: "Molestie at elementum eu facilisis. Pellentesque elit eget gravida cum sociis natoque. At auctor urna nunc id cursus metus aliquam. Malesuada bibendum arcu vitae elementum curabitur vitae nunc sed. Neque aliquam vestibulum morbi blandit cursus risus at ultrices mi. Condimentum id venenatis a condimentum vitae sapien pellentesque habitant. Nunc consequat interdum varius sit amet mattis vulputate enim. Vel turpis nunc eget lorem dolor sed viverra. Nunc non blandit massa enim. Quam pellentesque nec nam aliquam sem et tortor consequat. In hac habitasse platea dictumst quisque. Sit amet mattis vulputate enim nulla aliquet porttitor lacus luctus. Augue neque gravida in fermentum et sollicitudin ac orci.",
            },
            {
              id: 4,
              name: "LINKE",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
            {
              id: 5,
              name: "SPD",
              text: "Diam maecenas sed enim ut. Pellentesque adipiscing commodo elit at imperdiet dui. Nunc vel risus commodo viverra. Est sit amet facilisis magna etiam tempor orci eu lobortis. Magna fringilla urna porttitor rhoncus dolor purus. Est ullamcorper eget nulla facilisi etiam dignissim. Sed adipiscing diam donec adipiscing. Arcu felis bibendum ut tristique et egestas quis ipsum. Orci porta non pulvinar neque laoreet suspendisse interdum. Nibh nisl condimentum id venenatis a condimentum vitae sapien.",
            },
          ],
        },
      ],
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
        for (let j = 0; j < element.length; j++) {
          const el = element[j];
          if (el != undefined) this.result[j].score += Number(el);
        }
      }
      this.result = this.result.sort((a, b) => b.score - a.score);
      this.selecting = false;
    },
    reset() {
      this.refresh = !this.refresh;
      this.score = [];
      this.result = [];
      this.selecting = true;
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
  background: linear-gradient(to bottom, #f6a17c, #7a63a1);
}
</style>
