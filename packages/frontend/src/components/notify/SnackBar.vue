<template>
  <div class="text-center">
    <v-snackbar v-model="snackbar" multi-line :timeout="timeout">
      {{ text }}

      <template v-slot:actions>
        <v-btn rounded="pill" variant="text" @click="close()">
          {{ $t("notify.snackbar.close") }}
        </v-btn>
      </template>
    </v-snackbar>
  </div>
</template>

<script lang="ts">
import notify from "@/components/notify";

export default {
  data: () => ({
    snackbar: false,
    timeout: 5000,
    text: "",
  }),
  mounted() {
    notify.snackbar.listen((text: string) => {
      if (text.trim().length != 0) {
        this.text = text;
        this.snackbar = true;
      }
    });
  },
  methods: {
    close: function () {
      this.snackbar = false;
      this.text = "";
    },
  },
};
</script>
