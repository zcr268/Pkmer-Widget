<!--
 * @Author: cumany cuman@qq.com
 * @Date: 2023-03-05 15:02:39
 * @LastEditors: cumany cuman@qq.com
 * @LastEditTime: 2023-12-05 15:59:35
 * @FilePath: \pkmer-docs\src\components\Widget\SimpleCountdown\SimpleCountdown.vue
 * @Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
-->
<script setup lang="ts">
import tinycolor from "tinycolor2";
import {
  onMounted,
  ref,
  watch,
  watchEffect,
  onBeforeUnmount,
  nextTick,
} from "vue";
//这个文件是实际生成iframe用到的文件，读取配置信息，完整的功能
// 设置的类型定义
interface Props {
  widgetConfig: {
    [index: string]: any;
  };
}
// 从父组件读取配置
const props = defineProps<Props>();
const week_ZN = ["周日", "周一", "周二", "周三", "周四", "周五", "周六"];
const themeColor = ref(""); //basic

const start_p = ref(props.widgetConfig?.["date-picker"]);

const days = ref(0);
const minute = ref(0);
const second = ref(0);
const hours = ref(0);

const _now = ref(new Date().getTime());
const dateString = ref("");
const weekdayString = ref("");
const displayValue = ref("");
const textValue = ref("");
const isEditing = ref(false);
const inputRef = ref<HTMLElement | null>(null);
const inputDateRef = ref<HTMLElement | null>(null);
const selectedDate = ref("");
const showPicker = ref(false);
//input默认值
const defaultdate = new Date(props.widgetConfig?.["date-picker"])
  .toLocaleDateString("zh-CN", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  })
  .replace("/", "-")
  .replace("/", "-");
const handleClickDate = () => {
  showPicker.value = true;
  nextTick(function () {
    inputDateRef.value?.focus();
  });
};
const handleClick = () => {
  isEditing.value = true;
  nextTick(function () {
    inputRef.value?.focus();
  });
};

const handleBlur = () => {
  localStorage.setItem("SimpleCountdown-textValue", textValue.value);
  isEditing.value = false;
};
const handleBlurDate = () => {
  localStorage.setItem("SimpleCountdown-selectedDate", selectedDate.value);
  showPicker.value = false;
};
//设置项调整能同步input
watch(start_p, (newValue, oldValue) => {
  selectedDate.value = new Date(newValue as Date)
    .toLocaleDateString("zh-CN", {
      year: "numeric",
      month: "2-digit",
      day: "2-digit",
    })
    .replace("/", "-")
    .replace("/", "-");
});
watchEffect(() => {
  displayValue.value = props.widgetConfig["input-text"] || "年底";

  themeColor.value = props.widgetConfig["theme-color"]
    ? props.widgetConfig["theme-color"]
    : "#7d7d7d";

  if (textValue.value) {
    displayValue.value = textValue.value;
  }

  start_p.value = props.widgetConfig?.["date-picker"];

  // 设置时间

  let myDate;

  if (selectedDate.value && selectedDate.value != defaultdate) {
    myDate = new Date(selectedDate.value);
  } else {
    myDate = new Date(start_p.value);
    selectedDate.value = defaultdate;
  }

  let times = myDate.getTime() - _now.value;
  days.value = Math.floor(times / 1000 / 60 / 60 / 24) + 1;

  times = Math.abs(times % (1000 * 24 * 60 * 60));
  hours.value = Math.floor(times / 1000 / 60 / 60);
  times = times % (1000 * 60 * 60);
  minute.value = Math.floor(times / 1000 / 60);
  times = times % (1000 * 60);
  second.value = Math.floor(times / 1000);

  const dayOfWeek = myDate.getDay();
  weekdayString.value = week_ZN[dayOfWeek];
  dateString.value = myDate.toLocaleDateString("zh-CN", {
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  });
});
let timerId: any = null;
onMounted(() => {
  const storedValue = localStorage.getItem("SimpleCountdown-textValue");
  if (storedValue) {
    textValue.value = storedValue;
  }
  const storedSelectedDate = localStorage.getItem(
    "SimpleCountdown-selectedDate"
  );
  if (storedSelectedDate) {
    selectedDate.value = storedSelectedDate;
  }
  timerId = setInterval(() => {
    _now.value = new Date().getTime();
  }, 1000);
});

onBeforeUnmount(() => {
  clearInterval(timerId);
});
</script>
<template>
  <div class="countdown-container">
    <div class="text-wrapper">
      <span class="title">
        <span id="title">
          <input
            ref="inputRef"
            v-if="isEditing"
            v-model="textValue"
            @blur="handleBlur"
          />

          <span v-if="!isEditing" @click="handleClick">
            {{ displayValue }}</span
          ></span
        ></span
      >
      <span class="status" v-if="days < 0">已过去</span>
      <span class="status" v-if="days > 0">还有</span>
      <span class="status" v-if="days == 0"> 就在今日 </span>
    </div>
    <div class="timer-wrapper">
      <span
        class="timer"
        v-if="!showPicker"
        id="date"
        @click="handleClickDate"
        >{{ days > 0 ? days : -days }}</span
      >
      <span class="timer" v-if="showPicker">
        <input
          ref="inputDateRef"
          type="date"
          id="date-input"
          @blur="handleBlurDate"
          v-model="selectedDate"
      /></span>
      <span class="unit">天</span>
    </div>
  </div>
</template>
<style scoped>
.countdown-container {
  --primary-color: #37352f;
  --primary-color-dark: #ffffffcf;
  --secondary-color: #37352fb2;
  --secondary-color-dark: #d4d4d4ab;

  --bg-color: #ffffff;
  --bg-color-dark: #191919;
  display: grid;
  place-content: center;
  place-items: center;

  overflow: hidden;
  color: v-bind(themeColor);
}

.text-wrapper {
  margin-bottom: 0.25rem;
  margin-left: 1rem;
}

.title {
  font-family: Inter, system-ui, Avenir, Helvetica, Arial, sans-serif;
  line-height: 1.5;
  font-weight: 400;
  font-size: 16px;
}

.status {
  opacity: 0.8;
  font-weight: 600;
}

.timer-wrapper {
  position: relative;
}

.timer {
  font-size: 3rem;
  font-weight: 500;
  line-height: 1;
}

.unit {
  position: absolute;
  bottom: 0;
  left: 100%;
  margin-bottom: 0.3rem;
  margin-left: 0.35rem;
  display: block;
  line-height: 1;
  border-radius: 2px;
  padding: 0.2rem;
  font-size: 0.875rem;
  font-weight: 500;
}

.unit {
  color: var(--bg-color-dark);
  background: var(--secondary-color-dark);
}
.countdown-container.dark .unit {
  color: var(--bg-color);
  background: var(--secondary-color);
}

input {
  width: 75%;
  padding: 6px 10px;
  margin: 8.002px 0;
  border: 1px solid #8b8b8b;
  border-radius: 8.002px;
  font-size: 16px;
  background: transparent;
  color: #747474;
}
</style>
