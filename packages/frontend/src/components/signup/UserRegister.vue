<template>
  <v-card class="mx-auto" width="344" :title="$t('signup.form.title')">
    <v-container>
      <v-form v-model="form" @submit.prevent="onSubmit">
        <v-text-field
          v-model="email"
          :readonly="loading"
          :rules="[required]"
          clearable
          type="email"
          label="Email"
          variant="underlined"
          :error-messages="errors.email"
          name="email"
        ></v-text-field>

        <v-text-field
          v-model="password"
          :readonly="loading"
          :rules="[required]"
          clearable
          :label="$t('form.user.password')"
          type="password"
          variant="underlined"
          :error-messages="errors.password"
          name="password"
        ></v-text-field>

        <v-card-actions>
          <v-row justify="space-between">
            <v-btn @click="goSignIn" variant="text" :disabled="loading">
              {{ $t("signin.title") }}
            </v-btn>

            <v-btn
              type="submit"
              :disabled="loading"
              :loading="loading"
              color="success"
            >
              {{ $t("form.save") }}
            </v-btn>
          </v-row>
        </v-card-actions>
      </v-form>
    </v-container>
  </v-card>
</template>

<script lang="ts">
import { Signup } from "@/service/signup";

export default {
  data: () => ({
    form: false,
    email: null,
    password: null,
    loading: false,
    errors: { email: "", password: "" },
  }),

  methods: {
    async onSubmit() {
      this.cleanError();
      this.loading = true;
      await Signup({
        email: this.email || "",
        password: this.password || "",
      }).then((response) => {
        this.loading = false;

        this.errorMessages(response.errors || []);
      });
    },
    required(value: String) {
      return !!value || this.$t("form.field_required");
    },
    errorMessages(errors: []) {
      if (errors.length > 0) {
        let listError = {} as any;
        const error = errors.pop() || {};

        Object.keys(error).forEach(
          (key) => (listError[key] = { ...error }[key])
        );
        this.errors = { ...this.errors, ...listError };
      }
    },
    cleanError() {
      this.errors = { email: "", password: "" };
    },
    goSignIn() {
      this.$router.push("/signin");
    },
  },
};
</script>
